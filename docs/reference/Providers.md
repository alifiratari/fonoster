<a name="Providers"></a>

## Providers ⇐ <code>FonosService</code>
Use Fonos Providers, a capability of Fonos SIP Proxy subsystem,

**Kind**: global class  
**Extends**: <code>FonosService</code>  
**See**: module:core:FonosService  

* [Providers](#Providers) ⇐ <code>FonosService</code>
    * [new Providers()](#new_Providers_new)
    * [.createProvider(request)](#Providers+createProvider) ⇒ <code>Promise.&lt;Object&gt;</code>
    * [.getProvider(ref)](#Providers+getProvider) ⇒ <code>Promise.&lt;Object&gt;</code>
    * [.updateProvider(request)](#Providers+updateProvider) ⇒ <code>Promise.&lt;Object&gt;</code>
    * [.listProviders(request)](#Providers+listProviders) ⇒ <code>Promise.&lt;ListProvidersResponse&gt;</code>
    * [.deleteProvider(ref)](#Providers+deleteProvider)

<a name="new_Providers_new"></a>

### new Providers()
Constructs a new Providers object.

**Example**  
```js
const Fonos = require('@fonos/sdk')
```
<a name="Providers+createProvider"></a>

### providers.createProvider(request) ⇒ <code>Promise.&lt;Object&gt;</code>
Creates a new Provider on the SIP Proxy subsystem.

**Kind**: instance method of [<code>Providers</code>](#Providers)  

| Param | Type | Description |
| --- | --- | --- |
| request | <code>Object</code> | Request for the provision of a new Provider |
| request.name | <code>string</code> | Friendly name to the Provider |
| request.username | <code>string</code> | Username for the trunk. No required for static IP authentication |
| request.secret | <code>string</code> | Password for the trunk. No required for static IP authentication |
| request.host | <code>string</code> | Hostname or IP of the Provider |
| request.transport | <code>string</code> | The transport for the Provider. Fonos will use TCP if none is provided |
| request.expires | <code>string</code> | Expiration time for the registration. Fonos will use 3600 if non is provided |

**Example**  
```js
const request = {
```
<a name="Providers+getProvider"></a>

### providers.getProvider(ref) ⇒ <code>Promise.&lt;Object&gt;</code>
Retrives a Provider by its reference.

**Kind**: instance method of [<code>Providers</code>](#Providers)  
**Returns**: <code>Promise.&lt;Object&gt;</code> - The provider  
**Throws**:

- if ref is null or Provider does not exist


| Param | Type | Description |
| --- | --- | --- |
| ref | <code>string</code> | Reference to Provider |

**Example**  
```js
providers.getProvider(ref)
```
<a name="Providers+updateProvider"></a>

### providers.updateProvider(request) ⇒ <code>Promise.&lt;Object&gt;</code>
Update a Provider at the SIP Proxy subsystem.

**Kind**: instance method of [<code>Providers</code>](#Providers)  

| Param | Type | Description |
| --- | --- | --- |
| request | <code>Object</code> | Request to update a Provider |
| request.ref | <code>string</code> | Providers reference |
| request.name | <code>string</code> | Friendly name to the Provider |
| request.username | <code>string</code> | Username for the trunk. No required for static IP authentication |
| request.secret | <code>string</code> | Password for the trunk. No required for static IP authentication |
| request.host | <code>string</code> | Hostname or IP of the Provider |
| request.transport | <code>string</code> | The transport for the Provider. Fonos will use TCP if none is provided |
| request.expires | <code>string</code> | Expiration time for the registration. Fonos will use 3600 if non is provided |

**Example**  
```js
const request = {
```
<a name="Providers+listProviders"></a>

### providers.listProviders(request) ⇒ <code>Promise.&lt;ListProvidersResponse&gt;</code>
List the Providers registered in Fonos SIP Proxy subsystem.

**Kind**: instance method of [<code>Providers</code>](#Providers)  
**Returns**: <code>Promise.&lt;ListProvidersResponse&gt;</code> - List of Providers  

| Param | Type | Description |
| --- | --- | --- |
| request | <code>Object</code> |  |
| request.pageSize | <code>provider</code> | Provider of element per page (defaults to 20) |
| request.pageToken | <code>string</code> | The next_page_token value returned from a previous List request, if any |

**Example**  
```js
const request = {
```
<a name="Providers+deleteProvider"></a>

### providers.deleteProvider(ref)
Deletes a Provider from SIP Proxy subsystem. Notice, that in order to delete

**Kind**: instance method of [<code>Providers</code>](#Providers)  

| Param | Type | Description |
| --- | --- | --- |
| ref | <code>string</code> | Reference to the Provider |

**Example**  
```js
const ref = '507f1f77bcf86cd799439011'
```