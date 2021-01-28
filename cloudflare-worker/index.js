addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request));
});

const NOTSET = Symbol('NOTSET');
const ALLOWED_ORIGIN = 'https://static.spaceage.mp';

async function apiFetch(url, origin, ip) {
    const res = await fetch(`https://api.spaceage.mp${url}`, {
        headers: {
            'Client-ID': `SpaceAge/Aggrgator [${origin}] (${ip})`,
        },
    });

    let data = await res.text();
    try {
        data = JSON.parse(data);
    } catch { }

    return {
        response: {
            code: res.status,
            data: data,
        },
        cache: res.headers.get('Cache-Control'),
    };
}

async function handleRequest(request) {
    const url = new URL(request.url);
    const origin = request.headers.get('Origin');
    const ip = request.headers.get('CF-Connecting-IP');

    if (url.pathname !== '/cdn/aggregate') {
        return new Response('Route not found', { status: 404 });
    }

    if (request.method !== 'GET') {
        return new Response('Invalid method', { status: 405 });
    }

    if (origin !== ALLOWED_ORIGIN) {
        return new Response('Invalid caller', { status: 403 });
    }

    const routes = [...new Set(url.searchParams.getAll('run'))];
  
    let cacheValid = true;
    let cacheHeader = NOTSET;

    const apiFetches = new Map();
    await Promise.all(
        routes
        .filter(route => route.startsWith('/v2/'))
        .map(route => 
            apiFetch(route, origin, ip)
            .then(res => { apiFetches.set(route, res); })
        ),
    );

    const response = {};
    for (const [route, apiReply] of apiFetches.entries()) {
        if (cacheValid) {
            if (cacheHeader !== NOTSET && apiReply.cache !== cacheHeader) {
                cacheValid = false;
            }
            cacheHeader = apiReply.cache;
        }
        response[route] = apiReply.response;
    }

    if (!cacheValid || !cacheHeader || cacheHeader === NOTSET) {
        cacheHeader = 'private, no-cache, no-store, max-age=0';
    }
    
    return new Response(JSON.stringify(response), {
        status: 200,
        headers: {
            'Content-Type': 'application/json',
            'Cache-Control': cacheHeader,
            'Access-Control-Allow-Methods': 'GET',
            'Access-Control-Allow-Origin': ALLOWED_ORIGIN,
            'Vary': 'Origin',
        },
    });
}
