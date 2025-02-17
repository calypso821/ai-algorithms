# Data Analysis & Algorithms Projects Collection

This repository contains three comprehensive projects showcasing different aspects of computer science and data analysis:

1. **Search Algorithms Implementation** - Comparison of uninformed vs. informed search strategies, analyzing performance tradeoffs
2. **NBA Game Prediction System** - Machine learning models for game outcome prediction with in-game statistics
3. **Tree Growth Analysis** - Statistical modeling of height-diameter relationships using regression techniques

---

## 1. Search Algorithms Implementation

### Algorithms Overview

#### Uninformed Search
- DFS (Depth-First Search): Fast execution with stack implementation, non-optimal paths
- BFS (Breadth-First Search): Optimal paths using queue, higher memory usage
- IDDFS (Iterative Deepening DFS): Combines DFS benefits with optimal path finding

#### Informed Search
- GBFS (Greedy Best-First Search): Very fast execution using priority queue, non-optimal paths
- A* (A-Star): Optimal paths with efficient state exploration but high memory usage
- IDA* (Iterative Deepening A*): Memory-efficient version of A* with optimal path finding

### Metrics Explained
- Length: Number of steps in the found solution path
- States: Total number of states examined during search
- Memory: Maximum number of elements stored in memory
- Time: Execution time in milliseconds

### Performance Results
```
Uninformed Search:
DFS:    Length: 29    States: 72        Memory: 31        Time: 5ms
BFS:    Length: 8     States: 99361     Memory: 53505     Time: 330ms
IDDFS:  Length: 8     States: 184498    Memory: 8         Time: 162ms

Informed Search:
GBFS:   Length: 10    States: 18        Memory: 163       Time: 1ms
A*:     Length: 8     States: 216       Memory: 1259      Time: 3ms
IDA*:   Length: 8     States: 1051      Memory: 17        Time: 2ms
```

### Key Findings
1. Informed searches examine significantly fewer states
2. BFS and IDDFS find optimal paths but examine more states
3. Informed searches are faster but require heuristic functions
4. IDA* provides best balance of memory usage and path optimality

---

## 2. NBA Game Prediction Analysis

### Project Overview
Analysis and prediction of NBA game outcomes using historical data from 2012-2018 seasons, focusing on both winner classification and score difference regression.

### Data Processing & Features
- Game statistics converted to ratios (shots, attacks, team form)
- Team performance metrics from last 5 games
- Quarter-by-quarter score differences
- Target variables: Home team win (classification) and score difference (regression)

### Implementation
- Training: 2012-16 seasons (~360 games per team)
- Testing: 2016-17 season
- Models: Decision Trees, Random Forest, KNN (k=10), Naive Bayes/SVM

### Results
**Classification:**
- Baseline accuracy: 0.56 (correctly predicts game winner 56% of the time)
- Best model (Random Forest): 0.58 (58% correct predictions)
- With quarter scores: +25% improvement

**Regression (RMAE):**
- Best model (Random Forest): 0.99 (average prediction error is 99% of actual score difference)
- Performance doubled when including 3rd quarter scores

For example: with RMAE of 0.99, if the actual score difference is 10 points, the model's prediction would be off by approximately 9.9 points on average.

**Key Finding:** Including in-game score differences (after 3 quarters) significantly improves prediction accuracy across all models.

---

## 3. Tree Height-Diameter Analysis

### Dataset
- 50 measurements of tree diameter (at 1.37m height) and total tree height
- Diameter range: 1.1m - 10.1m (mean: 4.18m)
- Height range: 9.5m - 39m (mean: 24.6m)

### Methods
- Linear regression model comparing both direct and log2-transformed diameter data
- Model validation through:
  - Linearity tests
  - Normality tests
  - Variance homogeneity analysis
  - Cook's distance influence analysis

### Key Results
- Strong correlation between diameter and height (r = 0.865)
- Improved correlation with log2-transformed diameter (r = 0.924)
- Final model: height = 8.07 * log2(diameter) + 9.48
- Model explains 85% of variance (R² = 0.854)
- Successfully validated all regression assumptions
- Prediction example: 
  - 4m diameter tree → 25.6m height (95% CI: 20.4-30.8m)

### Conclusion
Confirmed functional relationship between tree diameter and height, with log-transformation providing better model fit than raw measurements.