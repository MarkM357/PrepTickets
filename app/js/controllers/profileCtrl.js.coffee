profileCtrl = @prepTickets.controller "profileCtrl", ($scope, $location, ProfileService) ->
  $scope.Contact = {}
  $scope.processingRequest = false
  $scope.loadProfile = ->
    $scope.auth.loadProfile().then(
      (profile) ->
        $scope.root.DomainProfile = profile
        angular.copy(profile.Contact, $scope.Contact)
      (err) ->
        $scope.error.log err
    )
  $scope.saveProfile = ->
    if $scope.profileForm.$valid and not $scope.processingRequest
      $scope.flash.clear()
      $scope.processingRequest = true
      ProfileService.saveContact($scope.Contact).then(
        (result) ->
          $scope.processingRequest = false
          $scope.flash("Your profile has been updated")
          $scope.auth.loadProfile(true)
          $location.path("/profile")
        (err) ->
          $scope.processingRequest = false
          $scope.error.log err
      )
    else
      $scope.flash("error", "Unable to save, please check the form for any errors and try again").now()

  $scope.savePassword = ->
    if $scope.passwordForm.$valid and not $scope.processingRequest
      $scope.flash.clear()
      $scope.processingRequest = true
      ProfileService.savePassword($scope.Contact.NewPassword).then(
        (success) ->
          $scope.processingRequest = false
          $scope.flash("You've successfully changed your password")
          $location.path("/profile")
        (err) -> 
          $scope.processingRequest = false
          $scope.error.log err
      )
    else
      $scope.flash("error", "Unable to save, please check the form for any errors and try again").now()


profileCtrl.$inject = ["$scope", "$location", "ProfileService"]