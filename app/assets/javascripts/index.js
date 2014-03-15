$(document).ready(initSortByColumn);
$(document).on('page:load', initSortByColumn);

function initSortByColumn() {
  var options = {
    valueNames: ['name', 'location', 'description']
  };

  var eventsList = new List('events-list', options);
}