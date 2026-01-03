# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :products,
          resolver: Queries::ProductsQuery,
          description: 'Returns products connection. Supports filtering by promoted and type. Uses Relay Connections for pagination (first/after, last/before)'

    field :is_user_logged,
          resolver: Queries::Users::IsUserLoggedQuery,
          description: "Returns info if user's session is present"

    field :user,
          resolver: Queries::Users::UserQuery,
          description: 'Returns user'

    field :products_categories,
          resolver: Queries::ProductCategories::ProductCategoriesQuery,
          description: 'Returns array fo products categories'

    field :opinions,
          resolver: Queries::Opinions::OpinionsQuery,
          description: 'Returns array of opinions'

    field :orders,
          resolver: Queries::Orders::OrdersQuery,
          description: 'Returns array of order'
  end
end
