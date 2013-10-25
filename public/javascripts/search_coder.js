application.SearchCoder = function() {
    var self = this;
    self.eventListeners();
};

application.SearchCoder.prototype.eventListeners = function() {
    var self = this;
    $('.js-tech').change(function(){
      var $element = $(this);
      if($element.prop('checked')) {
        if($element.val() == 'techy') {
          $('.js-tech-fields').show();
          $('.js-non-tech-fields').hide();          
        } else {
          $('.js-tech-fields').hide();
          $('.js-non-tech-fields').show();
        }
      }
    });    
    $('.js-characteristics, .js-experience').change(function(){
      var $element = $(this);
      var checked = $element.prop('checked');
      var $correspondingElement = $('#js-' + ($element.hasClass('js-characteristics') ? 'language' : 'followers') + '-' + $element.val().replace('..', '-').replace('>=', ''));
      $correspondingElement.prop('checked', checked);
    });    
    $('.js-language, .js-followers').change(function(){
      var $element = $(this);
      var checked = $element.prop('checked');
      var $correspondingElement = $('#js-' + ($element.hasClass('js-language') ? 'characteristics' : 'experience') + '-' + $element.val().replace('..', '-').replace('>=', ''));
      $correspondingElement.prop('checked', checked);
    });    
    $('.js-user-search').submit(function(){
      $('.js-user-search').addClass('pending');
      var q = '';
      var language = '';
      $('.js-language').each(function(){
        if($(this).is(':checked')) {
          if(language.length > 0) {
            language += '&';
          }
          language += $(this).val();
        }
      });
      if(language.length > 0) {
        if(q.length > 0) {
          q += '%2B';
        }
        q += 'language:' + language;
      }
      var followers = '';
      $('.js-followers').each(function(){
        if($(this).is(':checked')) {
          followers = $(this).val();
        }
      });
      if(followers.length > 0) {
        if(q.length > 0) {
          q += '%2B';
        }
        q += 'followers:' + followers;
      }
      if($('.js-location').val().length > 0) {
        if(q.length > 0) {
          q += '%2B';
        }
        q += 'location:' + $('.js-location').val();
      }
      if(q.length === 0) {
        $('.js-user-search').removeClass('pending');
        alert('no crits');
        return false;
      }
      var url = '/github_users?type=users&q=' + q;
      $.ajax({
        url: url,
        format: 'html/text',
        success: function(data) {
          if(data) {
            $('.js-user-results ul').html(data);
          } else {
            self.checkSecondsToWait(self.noResult);
          }
        },
        complete: function() {
          console.log(url);
          $('.js-user-search').removeClass('pending');
        }
      });
      return false;
    });
    $(window).resize(function() {
      $('body').css("position", 'relative');
    });
};

application.SearchCoder.prototype.noResult = function() {
  var self = this;
  console.log('ö');
  $('.js-user-results ul').html('<li class="no-result">No coders where found. :/</li>');
};

application.SearchCoder.prototype.checkSecondsToWait = function(callbackIfLimitIsLeft) {
  var self = this;
  var url = '/github_limits';
  $.ajax({
    url: url,
    format: 'json',
    success: function(secondsToReset) {
      if(secondsToReset > 0) {
        self.showWaitForRateLimit(secondsToReset)
      } else if(callbackIfLimitIsLeft) {
        callbackIfLimitIsLeft();
      }
    },
    complete: function() {
    }
  });
};

application.SearchCoder.prototype.showWaitForRateLimit = function(secondsToReset) {
  var self = this;
  $('.js-user-results ul').html();
  $('body').append('<div class="js-modal-background modal-background"><div class="js-waiting-counddown waiting-counddown"><div class="countdown">' + secondsToReset + '</div>overloaded, but we will be back soon!</div></div>');
  self.waitingInterval = setInterval(function(){
    secondsToReset--;
    $('.js-waiting-counddown .countdown').html(secondsToReset);
    if(secondsToReset <= 0) {
      clearInterval(self.waitingInterval);
      setTimeout(function(){
        $('.js-modal-background').remove();
      }, 1000);
    }
  }, 1000);
};
