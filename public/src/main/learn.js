/* eslint-disable
    camelcase,
    handle-callback-err,
    max-len,
    no-return-assign,
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['base', 'directives/mathjax', 'services/algolia-search'], function(
  App
) {
  App.controller('SearchWikiController', function(
    $scope,
    algoliaSearch,
    _,
    $modal
  ) {
    $scope.hits = []

    $scope.clearSearchText = function() {
      $scope.searchQueryText = ''
      return updateHits([])
    }

    $scope.safeApply = function(fn) {
      const phase = $scope.$root.$$phase
      if (phase === '$apply' || phase === '$digest') {
        return $scope.$eval(fn)
      } else {
        return $scope.$apply(fn)
      }
    }

    const buildHitViewModel = function(hit) {
      const page_underscored = hit.pageName.replace(/\s/g, '_')
      const section_underscored = hit.sectionName.replace(/\s/g, '_')
      let content = hit._highlightResult.content.value
      // Replace many new lines
      content = content.replace(/\n\n+/g, '\n\n')
      const lines = content.split('\n')
      // Only show the lines that have a highlighted match
      const matching_lines = []
      for (let line of Array.from(lines)) {
        if (!/^\[edit\]/.test(line)) {
          content += line + '\n'
          if (/<em>/.test(line)) {
            matching_lines.push(line)
          }
        }
      }
      content = matching_lines.join('\n...\n')
      const result = {
        name:
          hit._highlightResult.pageName.value +
          ' - ' +
          hit._highlightResult.sectionName.value,
        url: `/learn/${page_underscored}#${section_underscored}`,
        content
      }
      return result
    }

    var updateHits = hits => $scope.safeApply(() => ($scope.hits = hits))

    return ($scope.search = function() {
      const query = $scope.searchQueryText
      if (query == null || query.length === 0) {
        updateHits([])
        return
      }

      return algoliaSearch.searchWiki(query, function(err, response) {
        if (response.hits.length === 0) {
          return updateHits([])
        } else {
          const hits = _.map(response.hits, buildHitViewModel)
          return updateHits(hits)
        }
      })
    })
  })

  return App.controller('LearnController', function() {})
})
