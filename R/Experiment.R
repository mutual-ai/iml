## TODO: add parameter_list for initiation of Experiment, which contains experiment type specific parameters (e.g. grid_size for partial dependence plots)
## Or maybe it makes sense to have subclasses for each interpretability method that inherits from Experiment and has additional parameters
## TODO: Move most parameters to private()
Experiment = R6Class("Experiment", 
  public = list(
    name = 'Experiment', 
    X = NULL,
    sample.size = 100,
    sampler = function(){
      replace = self$sample.size > nrow(self$X)
      self$X[sample(1:nrow(self$X), size = self$sample.size, replace = replace), ]
    }, 
    X.sample = NULL,
    intervene = function(){self$X.sample},
    X.design = NULL,
    f = NULL, 
    Q = function(x){x},
    Q.results = NULL,
    weight.samples = function(){1}, 
    aggregate = function(){cbind(self$X.design, self$Q.results)}, 
    initialize = function(f, X){
      self$f = f
      self$X = X
    },
    conduct = function(...){
      if(!private$finished){
        # DESIGN experiment
        self$X.sample = self$sampler()
        self$X.design = self$intervene()
        # EXECUTE experiment
        self$Q.results = self$Q(self$f(self$X.design))
        w = self$weight.samples()
        # AGGREGATE measurments
        private$results = self$aggregate()
        private$finished = TRUE
      }
      self
    }, 
    data = function(){
      private$results
    }
  ), 
  private = list(
    results = NULL, 
    finished = FALSE
  )
)







