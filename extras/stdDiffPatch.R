getStdDiff <- function(meanObsLinked,
                       sdObsLinked,
                       meanObsNonLinked,
                       sdObsNonLinked) {
  pooledSd <- sqrt(sdObsLinked ^ 2 + sdObsNonLinked ^ 2)
  stdDiff <- (meanObsNonLinked - meanObsLinked) / pooledSd
  return(stdDiff)
}

# T3
# ccae
getStdDiff(meanObsLinked = 1060.01,
           sdObsLinked = 1206.57,
           meanObsNonLinked = 886.47,
           sdObsNonLinked = 1113.97)

# optum
getStdDiff(meanObsLinked = 885.02,
           sdObsLinked = 1103.29,
           meanObsNonLinked = 751.11,
           sdObsNonLinked = 985.63)


# E3
# ccae
getStdDiff(meanObsLinked = 1037.59,
           sdObsLinked = 1204.51,
           meanObsNonLinked = 926.64,
           sdObsNonLinked = 1131.93)

#optum
getStdDiff(meanObsLinked = 808.32,
           sdObsLinked = 1075.10,
           meanObsNonLinked = 794.99,
           sdObsNonLinked = 1025.10)

# F3
# ccae
getStdDiff(meanObsLinked = 1064.77,
           sdObsLinked = 1210.01,
           meanObsNonLinked = 879.59,
           sdObsNonLinked = 1107.74)

# optum
getStdDiff(meanObsLinked = 855.36,
           sdObsLinked = 1103.43,
           meanObsNonLinked = 750.73,
           sdObsNonLinked = 958.22)









