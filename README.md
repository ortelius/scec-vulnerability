# Ortelius v11 Domain Microservice
RestAPI for the Domain Object

## Version: 11.0.0

### Terms of service
<http://swagger.io/terms/>

**Contact information:**
Ortelius Google Group
ortelius-dev@googlegroups.com

**License:** [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

---
### /msapi/domain

#### GET
##### Summary

Get a List of Domains

##### Description

Get a list of domains for the user.

##### Responses

| Code | Description |
|------|-------------|
| 200  | OK          |

#### POST
##### Summary

Create a Domain

##### Description

Create a new Domain and persist it

##### Responses

| Code | Description |
|------|-------------|
| 200  | OK          |

### /msapi/domain/:key

#### GET
##### Summary

Get a Domain

##### Description

Get a domain based on the _key or name.

##### Responses

| Code | Description |
|------|-------------|
| 200  | OK          |
