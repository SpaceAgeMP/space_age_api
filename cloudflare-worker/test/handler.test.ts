import { handleRequest } from '../src/handler';
import makeServiceWorkerEnv from 'service-worker-mock';

declare var global: any;

describe('handle', () => {
  beforeEach(() => {
    Object.assign(global, makeServiceWorkerEnv());
    jest.resetModules();
  });

  test('handle GET 404', async () => {
    const result = await handleRequest(new Request('/', { method: 'GET' }));
    expect(result.status).toEqual(404);
  });

  test('handle GET aggregate', async () => {
    const result = await handleRequest(new Request('/cdn/aggregate', { method: 'GET' }));
    expect(result.status).toEqual(200);
    const data = await result.text();
    expect(data).toEqual('{}');
  });
});
