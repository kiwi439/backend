# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :register_user,
          mutation: Mutations::Users::RegisterMutation,
          description: 'Register user'

    field :login_user,
          mutation: Mutations::Users::LoginMutation,
          description: 'Login user'

    field :logout_user,
          mutation: Mutations::Users::LogoutMutation,
          description: 'Logout user'

    field :subscribe_user_to_newsletter,
          mutation: Mutations::Newsletter::Create,
          description: 'Save user to newsletter'

    field :unsubscribe_user_from_newsletter,
          mutation: Mutations::Newsletter::Destroy,
          description: 'Remove user from newsletter'

    field :update_user,
          mutation: Mutations::Users::UpdateMutation,
          description: 'Update user'

    field :remove_user,
          mutation: Mutations::Users::RemoveMutation,
          description: "Remove user's account"

    field :add_opinion,
          mutation: Mutations::Opinions::CreateMutation,
          description: "Add user's opinion"

    field :add_order,
          mutation: Mutations::Orders::CreateOrder,
          description: "Add user's order"

    field :monitor_resources,
          mutation: ::Mutations::Tools::MonitorResourcesMutation,
          description: "Publish resources's state on Kafka for monitoring purpose"
  end
end
