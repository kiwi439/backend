# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :products,
          resolver: Queries::ProductsQuery,
          description: 'Returns products connection. Supports filtering by promoted and type. Uses Relay Connections for pagination (first/after, last/before)'

    field :current_user,
          resolver: Queries::CurrentUserQuery,
          description: 'Returns current user from session'

    field :user,
          resolver: Queries::UserQuery,
          description: 'Returns user'

    field :opinions,
          resolver: Queries::OpinionsQuery,
          description: 'Returns opinions connection. Uses Relay Connections for pagination (first/after, last/before)'

    field :order,
          resolver: Queries::OrderQuery,
          description: 'Returns a single order by id for the current user'

    field :orders,
          resolver: Queries::OrdersQuery,
          description: 'Returns orders connection. Supports filtering by user_id. Uses Relay Connections for pagination (first/after, last/before)'

    field :invoice_pdf,
          resolver: Queries::InvoicePdfQuery,
          description: 'Returns Infakt invoice PDF as Base64 for the user'
  end
end
