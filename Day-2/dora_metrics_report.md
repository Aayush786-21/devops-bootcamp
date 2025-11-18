# DORA Metrics Calculation Report

## Given Data (1 Month Period)
- Total Deployments: **40**
- Deployments Causing Incidents: **6**
- Average Time from Commit to Production: **3 hours**
- 20 Working Days Assumed

## Incident Breakdown

| Incident | Detected Time | Resolved Time | Resolution Duration |
|----------|---------------|----------------|---------------------|
| 1 | 10:00 AM | 11:30 AM | 1 hr 30 mins |
| 2 | 2:00 PM | 2:45 PM | 45 mins |
| 3 | 9:00 AM | 11:00 AM | 2 hrs |
| 4 | 4:00 PM | 8:00 PM | 4 hrs |
| 5 | 1:00 PM | 1:30 PM | 30 mins |
| 6 | 11:00 AM | 3:00 PM | 4 hrs |

---

## 1. Deployment Frequency

**Formula:**  
```
Deployments per day = Total Deployments / Working Days
```

**Calculation:**  
```
40 / 20 = 2 deployments per day
```

**Answer:** **2 deployments/day**

---

## 2. Lead Time for Changes

Average time from code committed to running successfully in production.  
**Answer:** **3 hours**

---

## 3. Change Failure Rate (CFR)

**Formula:**  
```
CFR = (Failed Deployments / Total Deployments) × 100
```

**Calculation:**  
```
(6 / 40) × 100 = 15%
```

**Answer:** **15%**

---

## 4. Mean Time To Recovery (MTTR)

**Formula:**  
```
MTTR = Sum of Incident Resolution Times / Total Incidents
```

Total Resolution Time in Minutes:  
```
90 + 45 + 120 + 240 + 30 + 240 = 765 mins
```

```
MTTR = 765 mins / 6 = 127.5 mins ≈ 2.1 hours
```

**Answer:** **≈ 2.1 hours**

---

## 5. Performance Classification (Based on DORA Standards)

| Metric | Result | Category |
|--------|---------|----------|
| Deployment Frequency | 40/month | Elite |
| Lead Time for Changes | 3 hours | Elite |
| Change Failure Rate | 15% | Medium |
| MTTR | ~2.1 hours | Elite |

**Overall Classification:** **High Performer**

---

## Final Summary

| Metric | Value |
|--------|--------|
| Deployment Frequency | 2/day |
| Lead Time for Changes | 3 hrs |
| Change Failure Rate | 15% |
| MTTR | ~2.1 hrs |
| Classification | High Performer |

