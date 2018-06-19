function initTableFilter(){

  $('.js-table-filter-input').livequery('keyup', function() {
    var tableClass = $(this).data('table');
    var filterValue = $.trim($(this).val()).replace(/ +/g, ' ').toLowerCase().split(' ');
    var $rows = $('.' + tableClass + '> tbody > tr');

    $rows.hide().filter(function() {
      var text = $(this).text().replace(/\s+/g, ' ').toLowerCase();
      var matchesSearch = true;
      $(filterValue).each(function(index, value) {
        matchesSearch = (!matchesSearch) ? false : ~text.indexOf(value);
      });
      return matchesSearch;
    }).show();
  });
}
