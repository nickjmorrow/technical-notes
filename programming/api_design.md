# Api Design

## [If you want to design good APIs, start thinking like a designer](https://medium.com/livefront/if-you-want-to-design-good-apis-start-thinking-like-a-designer-9fbb22273ff2)

- When looking at an API, imagine a new user stumbling onto it. Imagine how easy or hard it would be for them to guess at how to use the API without reading any documentation
- Using strongly typed return types and parameters makes different parts of the API more discoverable (as opposed to using something like strings)

## [Pit of Success](https://blog.codinghorror.com/falling-into-the-pit-of-success/)

- Should be easy to "make the right choices", whether with an API, a console app, or a web app.
- Easy to follow best practices and harder (but not impossible) to follow wrong practices

## Terminologies

A resource is an object or representation f somethig, which has some data associated iwith it and there can be a seto f methods to operate it on it.

So animals, schools, and employees are resources and delete, add, update are the operations / methods to be performed on the resourcces.

Collections are just multiple resources, or a set of resources. Company (resource) => companies (collection)

URL (uniform resource locator) is a path through which a rsource and be located and actions can be performed on it

## Endpoints

URL endpoints shouldn't be '/getemployees' or '/updateemployees'. Instead, they should just refer to the collection ('employees'), and various HTTP methods (GET, PUT) can be used on that endpoint

If we only want to access oen part of the instance, we should always be able to pass in the `id` to the URL

`/companies` returns all companies, and `/companies/34` returns hte comapny with id 34. the `DELETE` METHOD FOR `/companies/34` should delete the company with that id.

If we store resources within a resource, the following examples provide guidelines:

`GET /companies/3/employees` returns all employees for hte company with id 3

`DELETE /companies/3/employees/45` deletes the specific employee 45 that belongs to company 3

`POST /companies` should create a new company and return the details of the new company created
