# EQBoostAI — Feature List

## Total: 78 Features

---

## Tab 1: Home Dashboard (16 features)
1. MoodRingView animated ring widget
2. Current mood emoji display (😊😢😰😠😌🤩😕🌟)
3. Mood score (1-100) with color coding
4. Welcome message with time-aware greeting
5. Today's insight from last journal entry
6. Quick Journal button
7. Quick Practice button
8. Weekly mood bar chart (7 days)
9. Streak badge with flame animation
10. Streak days counter
11. XP total display
12. Current level display
13. Navigation to Journal tab
14. Navigation to RolePlay tab
15. Theme-aware UI (dark mode)
16. Animated mood ring entrance animation

---

## Tab 2: Journal (20 features)
17. New Entry / History segmented control
18. Rich text entry field with placeholder
19. Emotion tag selector (Happy, Calm, Anxious, Sad, Angry)
20. EmotionCard selection with visual feedback
21. Intensity slider (1-10)
22. AI analysis generation (simulated)
23. Mood score calculation algorithm
24. Save journal entry
25. Journal history list view
26. JournalEntryCell with date, preview, emotion tags, score
27. Swipe-to-delete functionality
28. Date + time formatting
29. Mood score color indicator bar
30. Analysis result display
31. Empty state handling
32. Text placeholder show/hide logic
33. Entry limit validation
34. Success feedback alert
35. Keyboard handling
36. Scroll view for long content

---

## Tab 3: RolePlay (18 features)
37. All / Free / Premium category filter
38. Scenario list with cards
39. ScenarioCard with icon, title, description
40. Category badge (Job Interview, Dating, etc.)
41. Difficulty badge (Beginner/Intermediate/Advanced)
42. Duration display (minutes)
43. Lock icon for premium scenarios
44. Chevron navigation indicator
45. Tap animation feedback
46. ScenarioDetailView chat interface
47. AI conversation simulation
48. User message input field
49. Send button with icon
50. Chat bubble UI (user vs AI)
51. Message history display
52. Initial AI greeting message
53. 10 pre-configured scenarios
54. Scenario feedback generation

---

## Tab 4: Tasks (13 features)
55. Daily missions header
56. XP earned counter
57. StreakBadge component
58. Task list with TaskCell
59. Category icon display (Awareness/Communication/Empathy/Boundaries/Self-Regulation)
60. Task title and description
61. XP reward badge
62. Completion checkbox animation
63. Tap to complete interaction
64. 5 daily auto-generated tasks
65. Empty state when no tasks
66. Swipe gesture disabled (tap only)
67. Auto-refresh on completion

---

## Tab 5: Profile (11 features)
68. Avatar circle with initials
69. User level display
70. Total XP display
71. Stats container (Streak/Journals/Social IQ)
72. Stat items with icon, value, label
73. Upgrade to Premium button
74. Premium upsell alert dialog
75. Settings table with 6 options
76. Dark Mode toggle (UI)
77. Notifications option (UI)
78. Privacy Policy / Terms / Support / Rate App options

---

## Architecture & Infrastructure
- MVVM pattern
- SQLite.swift local storage
- UserDefaults for preferences
- UIKit + SnapKit Auto Layout
- StoreKit 2 IAP ready
- Core Intelligence/Simulated AI
- Unit Tests + UI Tests
- Dark theme by default
- iOS 16.0+ support