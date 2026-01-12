# codeblitz3: Lidar Feature Engineering for Forest Structure

## 🎯 Learning Objectives

By the end of this Code Blitz, you should be able to:

-   Explain what a *feature* is in the context of ecological machine learning
-   Interpret lidar-derived feature definitions
-   Describe how different lidar feature families capture forest structure
-   Generate and map lidar features from a `.laz` tile in R

## Background

This Code Blitz focuses on **feature engineering** for forest structure using airborne lidar data. Our long-term goal is to develop spatially explicit models of forest structure (e.g., basal area, density, QMD, canopy cover) across the Ichauway landscape.

We will not yet focus on modeling algorithms, but instead on the **features** we create from lidar point clouds and how those features relate to forest structure.

### What do we mean by “features”?

In machine learning, **features** are:

-   Quantities derived from data **solely for the purpose of prediction**
-   Often abstract, engineered, redundant, and correlated
-   Not necessarily expected to have a one-to-one ecological interpretation
-   Valuable because, together, they capture structure in ways models can learn

Features differ from field measurements in an important way: we do not measure features directly - **we design them**.

-   NDVI example

## ⚙️ Group Exercise 1: Become an 'expert' in lidar metrics (20–25 min)

Lidar point clouds can be summarized in many ways. The `lidRmetrics` package organizes these summaries into several **feature families**, each emphasizing different aspects of vertical forest structure, including:

-   Height percentiles
-   Proportion of returns above height thresholds
-   Vertical dispersion metrics
-   Interval (layer-based) metrics
-   L moments
-   Voxel metrics
-   Kernel density estimation
-   GLCM texture metrics

Visit the [`lidRmetrics`](https://github.com/ptompalski/lidRmetrics)[ github page](#0) to read more about feature families

--

You will work in **3-4 teams**. Each team will become an expert and teach the rest of the group about selected lidar metrics.

1.  Browse the `lidRmetrics` documentation and list of available metrics
2.  You will be assigned **three feature families**. Choose **one feature from each family** assigned to your team.
3.  For each selected feature, your team will provide:
    1.  **A definition:** e.g., mathematical expression, logical description, code, or pseudocode
    2.  **A sketch or visual explanation:** e.g., Simple hand-drawn diagram, histogram of heights, vertical profile
    3.  **A link to forest structure:** e.g., explain which forest attributes might this feature help predict? (e.g., BA, density, QMD, canopy cover). Why might it be useful—or misleading? What aspect of forest structure does this feature emphasize? What information does it ignore?

Please note that you may need to do some of your own research to understand some of the mathematical terms. Share your understanding with the group. You can read the help files of the package, skim the referenced papers, or search terms online.

Be prepared to teach the group about your selected feature and responses.

## 🧪 Group Exercise 2: Calculating and Visualizing Features (25–30 min)

Now you’ll apply your selected features to real lidar data to visualize them

### Setup

-   Clone the repository to your local machine

-   Create your own branch to the repository

-   Create a new R script for you to practice the steps below.

-   Before leaving, be sure to (1) commit, (2) push, and (3) submit a pull request so your code can be uploaded.

Install and load required packages:

``` r
library(lidR)

#install package from github
devtools::install_github('ptompalski/lidRmetrics')
library(lidRmetrics)
```

Load a 1000 × 1000 m NEON .laz tile provided for this exercise. Remove noise, and normalize it (flatten terrain effects)

```         
#load tile, thin it for speed while we practice
las = readLAS('NEON_lidar_tile.laz', filter='-keep_random_fraction 0.5') 

# remove any points pre-classified by vendor as noise 18, 7
las = filter_poi(las, !Classification %in% c(18,7)) 

# Normalize heights, (zero out terrain)
las = normalize_height(las, algorithm=tin())

plot(las)
```

### Team Tasks

Using the same three features your team selected earlier:

-   Compute each feature using an appropriate function
-   Produce a raster map for each feature
-   Combine your features into a raster `stack`
-   Export your raster stack to the repository

For **each raster**, discuss within your team:

-   What spatial resolution is appropriate?
-   What information is lost or gained as resolution changes?
-   How might resolution affect downstream modeling?

There is no single “correct” resolution — **justify your choice**.

------------------------------------------------------------------------

### Outputs

Each team should be ready to show:

-   One or more feature rasters
-   A brief explanation of what spatial patterns you observe
-   How those patterns relate to forest structure

------------------------------------------------------------------------

## Wrap-up

As a group, we will compare feature choices, spatial patterns, and resolution decisions. The goal is **not** to identify “best” features, but to understand how different feature families encode forest structure in complementary ways.

These features will form the foundation for future sessions where we:

-   Scale feature extraction across the landscape
-   Combine multiple feature families
-   Train and evaluate predictive models
