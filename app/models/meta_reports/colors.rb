class MetaReports::Color

  #
  # Shared colors. The key is the class name, value is RGB in hex format
  #
  # Example: "highlight: 'ffcccc'" is 'tr.highlight {background: #ffcccc}' in CSS, and "$highlight: #ffcccc;"" as a SASS variable.
  #

  COLORS = {
    even:                   'efefef',
    odd:                    'ffffff',
    yellow:                 ['ffffaa', 'ffffcc', 'f9f9a4', 'f9f9c6'],
    highlight:          '$yellow_1 !important',
  }

end