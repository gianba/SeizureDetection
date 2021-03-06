# All packages and user defined functions used in the loadFile function (i.e., all 
# feature extraction function, etc. need to be specified here.)
# This is required by the doSnow package for parallel processing...
userFunctions <- c('getPath', 
                   'extractFeaturesForClip', 
                   'extractFeatures', 
                   'getFrequencyFeatures', 
                   'getFractalDimFeatures',
                   'getLyapunovFeature',
                   'getPCAFeatures',
                   'getCrossCorrelationFeatures',
                   'getMaxStepFeatures',
                   'getMaxAmplitudeChangeFeatures',
                   'getSlidingWindowFeatures')
usedPackages <- c('R.matlab',
                  'fractaldim',
                  'fractal')
