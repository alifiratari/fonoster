import grpc from 'grpc'
import {
  Domain,
  ListDomainsRequest,
  ListDomainsResponse,
  GetDomainRequest,
  CreateDomainRequest,
  UpdateDomainRequest,
  DeleteDomainRequest
} from '../protos/domains_pb'
import { Empty } from '../protos/common_pb'
import {
  IDomainsService,
  DomainsService,
  IDomainsServer
} from '../protos/domains_grpc_pb'
import { Kind, REncoder } from '../../common/resource_encoder'
import createResource from '../resources/create_resource'
import updateResource from '../resources/update_resource'
import domainDecoder from '../../common/decoders/domain_decoder'
import ResourceServer from '../resources/resource_server'
import getAccessKeyId from '../../common/get_access_key_id'

class DomainsServer extends ResourceServer implements IDomainsServer {
  constructor () {
    // Uselesss
    super(Kind.DOMAIN, domainDecoder)
  }

  async listDomains (
    call: grpc.ServerUnaryCall<ListDomainsRequest>,
    callback: grpc.sendUnaryData<ListDomainsResponse>
  ) {
    super.listResources(Kind.DOMAIN, domainDecoder, call, callback)
  }

  async createDomain (
    call: grpc.ServerUnaryCall<CreateDomainRequest>,
    callback: grpc.sendUnaryData<Domain>
  ) {
    const domain = call.request.getDomain()
    try {
      const resource = new REncoder(
        Kind.DOMAIN,
        domain.getName(),
        domain.getRef()
      )
        .withDomainUri(domain.getDomainUri())
        .withEgressPolicy(domain.getEgressRule(), domain.getEgressNumberRef())
        .withACL(domain.getAccessAllowList(), domain.getAccessDenyList())
        .withMetadata({ accessKeyId: getAccessKeyId(call) })
        .build()
      callback(null, await createResource(resource, domainDecoder))
    } catch (e) {
      callback(e, null)
    }
  }

  async updateDomain (
    call: grpc.ServerUnaryCall<UpdateDomainRequest>,
    callback: grpc.sendUnaryData<Domain>
  ) {
    const domain = call.request.getDomain()

    try {
      const resource = new REncoder(
        Kind.DOMAIN,
        domain.getName(),
        domain.getRef()
      )
        .withMetadata({
          createdOn: domain.getCreateTime(),
          modifiedOn: domain.getUpdateTime()
        })
        .withDomainUri(domain.getDomainUri())
        .withEgressPolicy(domain.getEgressRule(), domain.getEgressNumberRef())
        .withACL(domain.getAccessAllowList(), domain.getAccessDenyList())
        .build()
      callback(null, await updateResource(getAccessKeyId(call), resource, domainDecoder))
    } catch (e) {
      callback(e, null)
    }
  }

  async getDomain (
    call: grpc.ServerUnaryCall<GetDomainRequest>,
    callback: grpc.sendUnaryData<Domain>
  ) {
    super.getResource(Kind.DOMAIN, domainDecoder, call, callback )
  }

  async deleteDomain (
    call: grpc.ServerUnaryCall<DeleteDomainRequest>,
    callback: grpc.sendUnaryData<Empty>
  ) {
    super.deleteResource(Kind.DOMAIN, domainDecoder, call, callback)
  }
}

export { DomainsServer as default, IDomainsService, DomainsService }