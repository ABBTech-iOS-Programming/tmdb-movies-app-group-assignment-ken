[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/B6b_HS3f)
# 🎬 TMDB Movies App — Group Assignment

🚨 Git Rules

- Direct commits to `main` are not allowed
- Every feature must be implemented in a separate branch
- Every Pull Request must be reviewed by the teammate
- PRs without approval cannot be merged

## 🎨 Design
👉 https://www.figma.com/design/wNmnhNvAGFY75ZAZqMb3Iq/Movies-app--Community-

- Follow layout, screens, and navigation  
- Pixel-perfect accuracy is not required, but **structure and screens must match**

---

## 📡 API (TMDB)

You must use the following TMDB endpoints according to the design.

### Movie Lists
- **Trending**  
  https://developer.themoviedb.org/reference/trending-movies

- **Now Playing**  
  https://developer.themoviedb.org/reference/movie-now-playing-list

- **Popular**  
  https://developer.themoviedb.org/reference/movie-popular-list

- **Upcoming**  
  https://developer.themoviedb.org/reference/movie-upcoming-list

- **Top Rated**  
  https://developer.themoviedb.org/reference/movie-top-rated-list

### Search
- **Search Movie**  
  https://developer.themoviedb.org/reference/search-movie

### Movie Details
- **Movie Details**  
  https://developer.themoviedb.org/reference/movie-details

- **Reviews**  
  https://developer.themoviedb.org/reference/movie-reviews

### Watchlist
- **Add to Watchlist**  
  https://developer.themoviedb.org/reference/account-add-to-watchlist

- **Get Watchlist**  
  https://developer.themoviedb.org/reference/account-watchlist-movies

> Sign in to TMDB, obtain the account ID, and use it for Watchlist-related requests.

---

## 👥 Team Rules

### Task distribution
- Tasks must be divided between team members  
- Both team members must contribute meaningful code  

---

## 🌿 Git & Branching Rules

- ❌ No direct commits to `main`  
- ✅ Each feature must be implemented in a separate branch  
- ✅ Commits must be small, logical, and descriptive  

**Example branches:**
```text
feature/network-layer
feature/movie-lists
feature/movie-detail
feature/search
feature/watchlist
```

## 🔀 Pull Request & Review Flow

For every feature:

1. Implement the feature in your own branch  
2. Open a Pull Request to `main`  
3. The other team member must:
   - Review the code
   - Leave comments  
4. The author must:
   - Fix all comments
   - Push updates  
5. After comments are resolved → **merge the PR**

🚫 PRs without review must not be merged.
