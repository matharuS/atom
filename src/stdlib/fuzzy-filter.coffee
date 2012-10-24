stringScore = require 'stringscore'

module.exports = (candidates, query, options={}) ->
  if query
    scoredCandidates = candidates.map (candidate) ->
      string = if options.key? then candidate[options.key] else candidate
      score = stringScore(string, query)

      # Basename matches count for more.
      unless /\//.test(query)
        score += stringScore(candidate.replace(/^.*\//,''), query)

      { candidate, score }

    scoredCandidates.sort (a, b) ->
      if a.score > b.score then -1
      else if a.score < b.score then 1
      else 0
    candidates = (scoredCandidate.candidate for scoredCandidate in scoredCandidates when scoredCandidate.score > 0)

  candidates = candidates[0...options.maxResults] if options.maxResults?
  candidates