
angular.module('saya', ['ngCookies']);

function auth($scope, $http, $cookies){
  ['twitter', 'facebook'].forEach(function(target){
    // checkbox checked?
    var checked = function(){
      return $scope[target + "_name"]() !== undefined;
    };
    $scope[target + '_checked'] = checked;
    $scope[target + '_as']      = function(){
      if(checked()) return 'as';
    };

    // getters
    $scope[target + '_name']    = function(){
      return $cookies[target + '_name'];
    };

    // auth actions
    $scope[target + '_auth'] = function(){
      if(checked()){
        $cookies[target + '_name'] = undefined;
      }
      else{
        $http.post('/api/auth/' + target).success(
          function(data){ window.location = data; });
      }
    };
  });
};