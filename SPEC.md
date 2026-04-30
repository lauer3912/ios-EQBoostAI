# EQBoostAI — AI Emotional Intelligence & Social Skills Coach
## Specification Document

---

## 1. Project Overview

- **Project Name:** EQBoostAI
- **Bundle Identifier:** `com.ggsheng.EQBoostAI`
- **Core Functionality:** AI-powered emotional intelligence coach that helps users understand their emotions, practice social scenarios through AI roleplay, and build social skills through daily tasks and tracking.
- **Target Users:** Teens (13+), young adults, and middle-aged adults in Western markets (US, UK, CA, AU, DE, FR)
- **iOS Version Support:** iOS 16.0+
- **Languages:** English only (for Western market)

---

## 2. UI/UX Specification

### 2.1 Screen Structure

| Screen | Description | Navigation |
|--------|-------------|------------|
| SplashScreen | App launch branding | Auto-dismiss → Onboarding or Home |
| OnboardingFlow | 4 screens intro + premium upsell | PageTabView |
| HomeView | Dashboard with mood ring + quick actions | Tab 1 |
| JournalView | AI emotion analysis journal entry | Tab 2 |
| RolePlayView | AI scenario practice hub | Tab 3 |
| TasksView | Daily EQ tasks + streak tracking | Tab 4 |
| ProfileView | Stats, settings, subscription | Tab 5 |
| EmotionDetailView | Deep emotion analysis after journal | Push from Home/Journal |
| ScenarioDetailView | Individual roleplay scenario | Push from RolePlay |
| PremiumView | Subscription upsell | Modal |

### 2.2 Navigation Structure

```
UITabBarController (5 tabs)
├── Tab 1: HomeViewController (UINavigationController)
│   └── EmotionDetailViewController (push)
├── Tab 2: JournalViewController (UINavigationController)
│   └── ScenarioSetupViewController (push)
├── Tab 3: RolePlayViewController (UINavigationController)
│   └── ScenarioDetailViewController (push)
├── Tab 4: TasksViewController (UINavigationController)
└── Tab 5: ProfileViewController (UINavigationController)
    └── PremiumViewController (modal)
```

### 2.3 Visual Design

#### Color Palette
- **Primary:** #6C63FF (Indigo Purple — trust, wisdom)
- **Secondary:** #4ECDC4 (Teal — calm, growth)
- **Accent:** #FF6B9D (Rose Pink — emotion, warmth)
- **Background Dark:** #0F0F1A
- **Background Light:** #F8F9FF
- **Surface Dark:** #1A1A2E
- **Surface Light:** #FFFFFF
- **Text Primary Dark:** #FFFFFF
- **Text Primary Light:** #1A1A2E
- **Text Secondary Dark:** #A0A0B2
- **Text Secondary Light:** #6B6B80
- **Success:** #34D399
- **Warning:** #FBBF24
- **Error:** #F87171

#### Typography
- **Font Family:** SF Pro (system)
- **Heading 1:** 32pt Bold
- **Heading 2:** 24pt Semibold
- **Heading 3:** 20pt Semibold
- **Body:** 17pt Regular
- **Caption:** 13pt Regular
- **Button:** 17pt Semibold

#### Spacing System (8pt grid)
- **xs:** 4pt
- **sm:** 8pt
- **md:** 16pt
- **lg:** 24pt
- **xl:** 32pt
- **xxl:** 48pt

### 2.4 Component Library

#### MoodRingView
- Animated circular progress ring
- Color gradient based on mood (calm=teal → stressed=rose)
- Center shows current mood emoji + score
- Animates on appear (scale 0→1, 600ms ease-out)

#### EmotionCard
- Rounded corners 16pt, shadow
- Icon + emotion name + intensity bar
- Tap to select for journal tagging

#### ScenarioCard
- Hero image, title, difficulty badge, duration
- Tags: "conversation", "interview", "relationship"
- Lock icon if premium only

#### TaskCell
- Checkbox + task description + XP reward badge
- Swipe to complete

#### JournalEntryCell
- Date, preview text, emotion tags, mood score
- Swipe to delete

#### StreakBadge
- Flame icon + day count
- Glows when streak > 7 days

---

## 3. Functionality Specification

### 3.1 Core Features

#### Home Dashboard
- **Mood Ring Widget** — Live mood score (1-100) with animated ring
- **Today's Focus** — One key insight from last journal
- **Quick Journal** — One-tap to open journal with quick mood selector
- **Streak Counter** — Consecutive days of journal/Subscription
- **Weekly Mood Chart** — Bar chart of avg mood per day

#### AI Emotion Analysis Journal
- **Rich text entry** with placeholder prompts
- **Quick mood tags:** Happy, Sad, Anxious, Angry, Calm, Excited, Confused, Hopeful
- **AI Analysis** (simulated in MVP): emotion breakdown, triggers, trend vs last week
- **Save & reflect** — Store entries locally
- **History view** — Calendar + list view of past entries

#### AI Roleplay Scenarios
- **Scenario Categories:**
  - Job Interview
  - Difficult Conversation
  - First Date / Dating
  - Conflict Resolution
  - Public Speaking
  - Networking
  - Family Drama
  - Friend Drama
- **Difficulty Levels:** Beginner, Intermediate, Advanced
- **Conversation Flow:** User types response → AI replies → continues 5-10 turns
- **Feedback:** At end of scenario, AI gives feedback on communication style
- **Premium:** Only 3 free scenarios/month; unlimited for premium

#### Daily EQ Tasks
- Personalized daily missions based on user's goals
- Task categories: Awareness, Communication, Empathy, Boundaries, Self-Regulation
- XP system: Complete tasks → Earn XP → Level up
- Streak system: Daily completion maintains streak

#### Profile & Stats
- **Social IQ Score** — Calculated from journal patterns + task completion
- **Progress Charts:** Mood trends, streak history, XP progression
- **Goals Setting:** User selects focus areas (confidence, communication, relationships)
- **Settings:** Theme toggle, notifications, privacy, account
- **Subscription Management** via StoreKit 2

### 3.2 Architecture Pattern
- **MVVM** (Model-View-ViewModel)
- ViewModels as @Observable classes (Swift 5.9+)
- Combine for reactive bindings where needed
- Repository pattern for data access

### 3.3 Data Handling
- **Local Storage:** UserDefaults for preferences, SQLite.swift for journal entries + scenarios
- **No backend in MVP** — All AI responses simulated locally
- **StoreKit 2** for subscription IAP

### 3.4 Edge Cases & Error Handling
- Empty journal entry → Show warning before save
- Network unavailable → Show cached data + offline banner
- Subscription expired → Gracefully downgrade to free tier
- Streak broken → Show encouraging message, not punishing

---

## 4. Technical Specification

### 4.1 Dependencies (Swift Package Manager)

| Package | Version | Purpose |
|---------|---------|---------|
| SnapKit | 5.6.0 | Auto Layout DSL |
| SQLite.swift | 0.14.1 | Local database |
| Charts | 4.1.0 (DGCharts) | Data visualization |

### 4.2 Project Structure

```
ios-EQBoostAI/
├── project.yml
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── EQBoostAIApp.swift
├── Screens/
│   ├── Home/
│   │   ├── HomeViewController.swift
│   │   ├── HomeViewModel.swift
│   │   └── Views/
│   ├── Journal/
│   │   ├── JournalViewController.swift
│   │   ├── JournalViewModel.swift
│   │   └── Views/
│   ├── RolePlay/
│   │   ├── RolePlayViewController.swift
│   │   ├── RolePlayViewModel.swift
│   │   └── Views/
│   ├── Tasks/
│   │   ├── TasksViewController.swift
│   │   ├── TasksViewModel.swift
│   │   └── Views/
│   └── Profile/
│       ├── ProfileViewController.swift
│       ├── ProfileViewModel.swift
│       └── Views/
├── Components/
│   ├── MoodRingView.swift
│   ├── EmotionCard.swift
│   ├── ScenarioCard.swift
│   ├── TaskCell.swift
│   ├── JournalEntryCell.swift
│   └── StreakBadge.swift
├── Models/
│   ├── JournalEntry.swift
│   ├── Scenario.swift
│   ├── Task.swift
│   ├── UserProfile.swift
│   └── Emotion.swift
├── Services/
│   ├── DatabaseService.swift
│   ├── JournalService.swift
│   ├── ScenarioService.swift
│   ├── TaskService.swift
│   └── SubscriptionService.swift
├── Utilities/
│   ├── Theme.swift
│   ├── Constants.swift
│   └── Extensions.swift
├── Resources/
│   ├── Assets.xcassets/
│   ├── LaunchScreen.storyboard
│   └── Info.plist
└── Tests/
    ├── EQBoostAITests/
    └── EQBoostAIUITests/
```

### 4.3 Asset Requirements

#### App Icon
- 1024×1024 app icon (generated via image_generate tool)
- Style: Gradient purple-to-teal circle with white "S" letter, soft glow
- Theme: Abstract brain + heart fusion icon

#### SF Symbols Used
- house.fill, book.fill, person.2.fill, checkmark.circle.fill, person.crop.circle
- flame.fill, star.fill, lock.fill, chevron.right, plus.circle.fill
- heart.fill, face.smiling, bubble.left.and.bubble.right.fill

### 4.4 Entitlements
- App Groups: None (no widget in MVP)
- HealthKit: No
- Background Modes: None

### 4.5 Info.plist Keys
- CFBundleDisplayName: EQBoostAI
- CFBundleShortVersionString: 1.0.0
- CFBundleVersion: 1
- UILaunchStoryboardName: LaunchScreen
- UISupportedInterfaceOrientations: Portrait only
- ITSAppUsesNonExemptEncryption: NO

---

## 5. Subscription IAP (StoreKit 2)

### Products
- **EQBoostAI Premium:** $2.99/month
- Product ID: `com.ggsheng.EQBoostAI.premium.monthly`

### Access
- Free tier: 3 roleplay scenarios/month, basic journal, 3 daily tasks
- Premium: Unlimited scenarios, unlimited tasks, AI insights, advanced analytics

---

## 6. Privacy & Compliance

- No user data leaves device (MVP — all local)
- Privacy Policy URL: https://lauer3912.github.io/ios-EQBoostAI/docs/PrivacyPolicy.html
- App Store privacy questions: All "No" except "Support" category

---

*Last Updated: 2026-04-30*