module = angular.module('webappscenter.controllers', ['restangular'])

class GroupManagerCtrl
        constructor: (@$scope, @Restangular) ->
                @$scope.groups = []

                console.debug("fetching groups...")
                @Restangular.all('account/group').getList().then((groups) =>
                        @$scope.groups = angular.copy(groups)
                )


module.controller("GroupManagerCtrl", ['$scope', 'Restangular', GroupManagerCtrl])