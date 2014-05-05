module = angular.module('webappscenter.controllers', ['restangular', 'angular-unisson-auth'])

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

                # Remove user from local list
                updated_users = _.without(group.users, user)

                # Get resource path
                updated_users_rids = _.map(updated_users, (user) -> user.resource_uri)

                group.patch(users: updated_users_rids).then(->
                        group.users = updated_users
                )

        addUser: (group_id) =>
                group = _.find(@$scope.groups, (group) ->
                        return group.id == group_id
                )

                @Users.one(@$scope.new_user.username).get().then((user) =>
                        user_rids = _.map(group.users, (user) -> user.resource_uri)
                        updated_user_rids = _.clone(user_rids)
                        updated_user_rids.push(user.resource_uri)

                        group.patch(users: updated_user_rids).then(->
                                group.users = _.union(group.users, user)
                        )
                )


module.controller("GroupManagerCtrl", ['$scope', 'Groups', 'Users', GroupManagerCtrl])
