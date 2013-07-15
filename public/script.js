"use strict;"

angular.module('saya', ['ngCookies']);

function auth($scope, $http, $cookies){
  ['twitter', 'facebook'].forEach(function(target){
    // we need to make checkbox reflect authorization
    var set_checked = function(val){
      return $scope[target + '_checked'] = val;
    }
    var get_name = function(){
      return $cookies[target + '_name'];
    };
    var del_name = function(){
      $cookies[target + '_name'] = undefined;
    };
    var set_err  = function(val){
      if(val !== undefined) set_checked(false); // uncheck if there's an error
      del_name(); // we don't want to show error and name at the same time
      return $scope[target + '_err' ] = val;
    };
    var get_err  = function(){
      return $scope[target + '_err' ];
    };

    // angular views
    $scope[target + '_as']    = function(){
      if(get_name() !== undefined) return 'as';
    };
    $scope[target + '_name']  = function(){ return get_name(); };
    $scope[target + '_error'] = function(){ return get_err() ; };

    // auth actions
    $scope.$watch(target + '_checked', function(checked, previous_checked){
      if(checked === previous_checked) return; // angular issue

      if(checked){
        set_err(undefined);
        $http.post('/api/auth/' + target).
          success(function(data){ window.location = data ; }).
          error(  function(data){           set_err(data); });
      }
      else{
        del_name();
      }
    });

    // init model
    set_checked(get_name() !== undefined);
  });
};
