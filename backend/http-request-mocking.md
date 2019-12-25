# HTTP Request Mocking

## NodeJS

### [Nock](https://github.com/nock/nock)

- able to use `nock` to mock http requests
- can disable fetch requests during the test lifecycle (but how to disable axios requests? probably a way)
- can ensure no actual http requests are being made using `nock.disableNetConnect()`
- can verify mocks by using `scope.done()`, which should kill the nock scope, and then add another `nock` call to ensure you hit an error
- can handle query parameters using `.query()`
- all takes place outside the component because we swapped out `fetch` for our own `fetch`
