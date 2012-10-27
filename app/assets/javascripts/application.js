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


;(function() {
  var TmZone = {};

  $(document).ready(function() {
    var searcher = new TmZone.Searcher();

    $('#search').submit(function() {
      var form = $(this);

      $.post(form.attr('action'), form.serialize(), function(results_url) {
        searcher.search(results_url);
      });

      return false;
    });
  });

  TmZone.Searcher = function() {
    this.searchInProgress = false;

    this.marks = new TmZone.Marks($('.results'));
    this.paging = new TmZone.Paging($('.paging'));
    this.status = new TmZone.Status($('.status'));
    this.errors = new TmZone.Errors($('.errors'));
  }

  TmZone.Searcher.prototype.resetSearch = function() {
    if(this.searchInProgress) {
      this.source.close();

      this.marks.reset();
      this.paging.reset();
      this.status.reset();
      this.errors.reset();
    }
  }

  TmZone.Searcher.prototype.search = function(endpoint) {
    this.resetSearch();
    this.source = new EventSource(endpoint);

    this.searchInProgress = true;
    var self = this;

    self.status.searchStarted();

    self.source.addEventListener('results', function(e) {
      self.marks.appendMarks($.parseJSON(e.data));
    });

    self.source.addEventListener('failure', function(e) {
      self.errors.showError();
    });

    self.source.addEventListener('fatal', function(e) {
      self.errors.showError();
      self.status.searchFinished();
      self.source.close();
    });

    self.source.addEventListener('status', function(e) {
      self.paging.update($.parseJSON(e.data));
    });

    self.source.addEventListener('finished', function(e) {
      self.status.searchFinished();
      self.paging.consolidate();
      self.source.close();
    });
  }

  TmZone.Marks = function($el) {
    this.$el = $el;
  }
  TmZone.Marks.prototype.appendMarks = function(marks) {
    var self = this;
    $.each(marks, function(index, mark) {
      var $markEl = $('<div>');
      self.$el.append($markEl);
      var markView = TmZone.MarkViewFactory.viewFor(mark, $markEl);
      markView.render();
    });
  }
  TmZone.Marks.prototype.reset = function() {
    // Point src attribute of each image to '' to prevent it from loading.
    // #empty() removes the elements from DOM, but not from memory where they
    // continue loading.
    $('img', this.$el).attr("src", "");
    this.$el.empty();
  }

  TmZone.MarkViewFactory = {};
  TmZone.MarkViewFactory.viewFor = function(attributes, $el) {
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

    return new TmZone.MarkView($el, attributes, template);
  }

  TmZone.MarkView = function($el, json, template) {
    this.$el = $el;
    this.json = json;
    this.template = template;
  }
  TmZone.MarkView.prototype.render = function() {
    var html = HoganTemplates[this.template].render(this.json, { mark: HoganTemplates['_mark'].render(this.json) })
    this.$el.html(html);

    var self = this;
    this.$el.delegate(".show-details", "click", function() {
      $('.details', self.$el).show();
      return false;
    });
  }

  TmZone.Paging = function($el) {
    this.$el = $el;
  }
  TmZone.Paging.prototype.update = function(data) {
    data['total'] = "asi " + data['total'];
    this.data = data;
    this.render();
  }
  TmZone.Paging.prototype.reset = function() {
    this.$el.empty();
  }
  TmZone.Paging.prototype.render = function() {
    this.$el.html(HoganTemplates['paging'].render(this.data));
  }
  TmZone.Paging.prototype.consolidate = function() {
    this.data['total'] = this.data['fetched'];
    this.data['finished?'] = true
    this.render();
  }

  TmZone.Status = function($el) {
    this.$el = $el;
  };

  TmZone.Status.prototype.searchStarted = function() {
    this.$el.html(HoganTemplates['status_busy'].render());
  }

  TmZone.Status.prototype.searchFinished = function() {
    this.$el.html(HoganTemplates['status_finished'].render());
  }

  TmZone.Status.prototype.reset = function() {
    this.$el.empty();
  }

  TmZone.Errors = function($el) {
    this.$el = $el;
  }
  TmZone.Errors.prototype.showError = function() {
    this.$el.html(HoganTemplates['error'].render());
  }
  TmZone.Errors.prototype.reset = function() {
    this.$el.empty();
  }
})();
