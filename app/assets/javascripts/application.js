// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require hogan.js
//= require_tree .

$(document).ready(function() {
  $('#search').submit(function() {
    var form = $(this);

    $.post(form.attr('action'), form.serialize(), function(results_url) {
      var searcher = new Searcher(results_url);
      searcher.search();
    });

    return false;
  });
});

var Searcher = function(endpoint) {
  this.source = new EventSource(endpoint);

  this.marks = new Marks($('.results'));
  this.paging = new Paging($('.paging'));
  this.status = new Status($('.status'));
  this.errors = new Errors($('.errors'));
}

Searcher.prototype.search = function(endpoint) {
  var self = this;

  self.status.searchStarted();

  self.source.addEventListener('results', function(e) {
    self.marks.appendMarks($.parseJSON(e.data));
  });

  self.source.addEventListener('error', function(e) {
    self.errors.showError();
  });

  self.source.addEventListener('status', function(e) {
    self.paging.update($.parseJSON(e.data));
  });

  self.source.addEventListener('finished', function(e) {
    self.status.searchFinished();
  });
}

var Marks = function($el) {
  this.$el = $el;
}
Marks.prototype.appendMarks = function(marks) {
  var self = this;
  $.each(marks, function(index, mark) {
    $markEl = $('<div>');
    self.$el.append($markEl);
    var markView = MarkViewFactory.viewFor(mark, $markEl);
    markView.render();
  });
}

var MarkViewFactory = {};
MarkViewFactory.viewFor = function(attributes, $el) {
  var template;
  if(attributes.name != "" && attributes.illustration_url) {
    template = 'textual_visual_mark';
  } else if(attributes.name != "") {
    template = 'textual_mark';
  } else if(attributes.illustration_url) {
    template = 'visual_mark';
  } else {
    template = 'unavailable_mark';
  }

  return new MarkView($el, attributes, template);
}

var MarkView = function($el, json, template) {
  this.$el = $el;
  this.json = json;
  this.template = template;
}
MarkView.prototype.render = function() {
  var html = HoganTemplates[this.template].render(this.json, { mark: HoganTemplates['_mark'].render(this.json) })
  this.$el.html(html);

  var self = this;
  this.$el.delegate(".show-details", "click", function() {
    $('.details', self.$el).show();
    return false;
  });
}

var Paging = function($el) {
  this.$el = $el;
}
Paging.prototype.update = function(data) {
  this.$el.html(HoganTemplates['paging'].render(data));
}

var Status = function($el) {
  this.$el = $el;
};

Status.prototype.searchStarted = function() {
  this.$el.html(HoganTemplates['status_busy'].render());
}

Status.prototype.searchFinished = function() {
  this.$el.html(HoganTemplates['status_finished'].render());
}

var Errors = function($el) {
  this.$el = $el;
}
Errors.prototype.showError = function() {
  this.$el.html(HoganTemplates['error'].render());
}
