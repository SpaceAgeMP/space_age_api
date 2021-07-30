const NOTSET = Symbol('NOTSET');
const ALLOWED_ORIGIN = 'https://static.spaceage.mp';
const NOCACHE = 'private, no-cache, no-store, max-age=0';

function stubResponse(status, data) {
    return {
        response:{
            status,
            data,
            headers: {
                'content-type': 'text/plain',
            },
        },
        cache: NOCACHE,
    };
}

function validUrl(url) {
    if (!url.startsWith('/v2/')) {
        return false;
    }
    if (url.includes('/.')) {
        return false;
    }
    return true;
}

async function apiFetch(url, origin, ip) {
    if (!validUrl(url)) {
        return stubResponse(400, 'Bad/disallowed route');
    }


    const res = await fetch(`https://api.spaceage.mp${url}`, {
        headers: {
            'Client-ID': `SpaceAge/Aggrgator [${origin}] (${ip})`,
        },
    });

    const contentType = res.headers.get('Content-Type');
    const contentTypeReal = (contentType || 'text/plain').split(';')[0];
    let data;
    if (contentTypeReal === 'application/json') {
        data = await res.json();
    } else {
        data = await res.text();
    }

    return {
        response: {
            status: res.status,
            headers: {
                ['content-type']: contentType,
            },
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

    const routes = [...new Set(url.searchParams.getAll('run'))];
  
    let cacheValid = true;
    let cacheHeader = NOTSET;

    const apiFetches = new Map();
    await Promise.all(
        routes
        .map(route => 
            apiFetch(route, origin, ip)
            .then(
                res => {
                    apiFetches.set(route, res);
                },
                err => {
                    apiFetches.set(route, stubResponse(599, err.message));
                },
            )
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
        },
    });
}

addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request));
});
