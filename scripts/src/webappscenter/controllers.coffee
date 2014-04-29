module = angular.module('webappscenter.controllers', ['restangular'])

module.factory('Groups', (Restangular) ->
        return Restangular.service('account/group')
)

module.factory('Users', (Restangular) ->
        return Restangular.service('account/user')
)


class GroupManagerCtrl
        constructor: (@$scope, @Groups, @Users) ->
                @$scope.groups = @Groups.getList().$object

                @$scope.deleteUser = this.deleteUser
                @$scope.addUser = this.addUser

                @$scope.new_user = {}

        deleteUser: (group_id, user_rid) =>
                group = _.find(@$scope.groups, (group) ->
                        return group.id == group_id
                )

                user = _.find(group.users, (user) ->
                        return user.resource_uri == user_rid
                )

                updated_users = _.without(group.users, user)
                group.patch(users: updated_users).then(->
                        group.users = updated_users
                )

        addUser: (group_id) =>
                group = _.find(@$scope.groups, (group) ->
                        return group.id == group_id
                )

                @Users.one(@$scope.new_user.username).get().then((user) =>
                        user_rids = _.map(group.users, () -> user.resource_uri)
                        updated_user_rids = _.union(user_rids, user.resource_uri)
                        console.debug(updated_user_rids)
                        group.patch(users: updated_user_rids).then(->
                                group.users = _.union(group.users, user)
                        )
                )


module.controller("GroupManagerCtrl", ['$scope', 'Groups', 'Users', GroupManagerCtrl])
