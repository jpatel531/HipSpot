angular.module('HipSpot', ['pusher-angular']).controller('AppCtrl', ['$scope', '$pusher', function($scope, $pusher) {

	var songsChannel = pusher.subscribe('songs-channel');

	songsChannel.bind('new-song', function(song){
		
	});


}]);

