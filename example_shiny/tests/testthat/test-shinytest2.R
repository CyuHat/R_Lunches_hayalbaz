library(shinytest2)

test_that("{shinytest2} recording: example_shiny", {
  app <- AppDriver$new(name = "example_shiny", height = 609, width = 979)
  app$set_inputs(bins = 8)
  app$set_inputs(bins = 27)
  app$expect_values()
})
