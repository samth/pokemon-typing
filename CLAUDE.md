# Claude Instructions for Pokemon Typing Trainer

## Project Overview

This is a beginner-friendly typing trainer web app featuring Pokemon and My Little Pony characters. It's a single-file HTML application with no build process.

**Live Site**: https://samth.github.io/pokemon-typing/
**Repository**: https://github.com/samth/pokemon-typing

## Tech Stack

- **Pure HTML/CSS/JavaScript** - Single `index.html` file
- **No frameworks** - Vanilla JS only
- **No build process** - Direct deployment to GitHub Pages
- **External APIs**: PokeAPI for Pokemon data
- **External images**: PokeAPI sprites, Internet Archive for MLP

## Architecture

### File Structure
```
/
├── index.html (everything)
├── README.md
└── CLAUDE.md (this file)
```

### Key Components in index.html

1. **CSS** (`<style>` section):
   - CSS variables for theming (`:root`)
   - Retro/pixel aesthetic with scanlines
   - Press Start 2P font for headings
   - JetBrains Mono for code/typing

2. **HTML** (body):
   - Mode toggle (Pokemon/MLP)
   - Advanced mode checkbox
   - Hand position guide
   - Stats bar (streak, avg accuracy, completed)
   - Game container with speech bubble and character display
   - Hidden input field for typing

3. **JavaScript** (`<script>` section):
   - `sentences` object: All pre-made sentences (simple and advanced)
   - `state` object: Current game state
   - `fetchPokemon()`: Gets Pokemon data + species flavor text
   - `getSentenceForCharacter()`: Picks appropriate sentence
   - `loadNewSentence()`: Main game loop
   - Event handlers for input and mode switching

## Development Guidelines

### Code Style

- **Consistency**: Match existing style exactly
- **Comments**: Use `// ===` headers for major sections
- **Naming**: camelCase for variables, $prefix for DOM elements
- **Strings**: Use single quotes in JS, double quotes in HTML
- **Line length**: Keep reasonable, but prioritize readability

### Sentence Design Rules

**Simple Mode** (home row + close keys only):
- **Allowed keys**: `a s d f g h j k l` (home row) + `e r t c v n m` (close) + space
- **NO other letters**: (forbidden: `b i o p q u w x y z`)
- Keep punctuation minimal (no commas, periods, apostrophes, etc.)
- Progressive length: 15 → 25 → 35 → unlimited chars based on rounds

**IMPORTANT - Validation System**:
- The `ALLOWED_KEYS` constant in index.html defines valid characters
- All simple mode sentences are validated on page load
- Check browser console for validation errors (❌ marks invalid sentences)
- The keyboard diagram is generated from the same constant to ensure accuracy
- **Always check console after adding new sentences!**

**Advanced Mode**:
- Pokemon: Use PokeAPI species flavor_text_entries (English only)
- MLP: Full character descriptions in `*_advanced` sentence pools
- No character restrictions
- Can be as long as natural sentences require

### Adding New Features

**When adding sentences**:
- Simple mode: Verify ONLY home row + e,r,t,c,v,n,m are used
- Advanced mode: Focus on character personality and lore accuracy
- Add to appropriate theme/type category
- Test various lengths for progressive difficulty

**When modifying UI**:
- Maintain retro/pixel aesthetic
- Use existing CSS variables for colors
- Keep Press Start 2P for pixel text, JetBrains Mono for typing
- Test responsive behavior (mobile/desktop)

**When adding modes/features**:
- Save preferences to `localStorage`
- Update `state` object
- Don't break existing simple/advanced mode toggle
- Maintain backward compatibility with saved preferences

### API Usage

**PokeAPI**:
- Random Pokemon ID: 1-898 (Gen 1-8)
- Endpoint: `https://pokeapi.co/api/v2/pokemon/{id}`
- Species endpoint: `https://pokeapi.co/api/v2/pokemon-species/{id}`
- Always handle API failures gracefully with retries
- Clean flavor text: remove `\f`, `\n`, collapse whitespace

**Image Sources**:
- Pokemon: `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/{id}.png`
- MLP: Internet Archive verified PNGs (see `mlpCharacters` array)

## Git Workflow

### Commit Message Format

Always use this format:

```
<Short summary of changes>

<Detailed description with bullet points>
- Feature 1
- Feature 2
- Fix 3

Generated with [Claude Code](https://claude.ai/code)
via [Happy](https://happy.engineering)

Co-Authored-By: Claude <noreply@anthropic.com>
Co-Authored-By: Happy <yesreply@happy.engineering>
```

### Deployment

- **Main branch**: `master` (legacy, not main)
- **Auto-deploy**: GitHub Actions workflow triggers on every push to master
- **Workflow file**: `.github/workflows/deploy.yml`
- **Build time**: ~10-20 seconds for GitHub Actions deployment
- **No build step**: Just push index.html changes
- **Verification**: Check deployment status with `gh run list --limit 1`
- **Live site**: Changes appear at https://samth.github.io/pokemon-typing/ immediately after workflow completes

**GitHub Actions Workflow**:
- Triggers on every push to master
- Uses official `actions/deploy-pages@v4`
- Uploads entire repository as artifact
- Deploys to GitHub Pages environment
- Provides deployment URL in workflow output

### Branch Protection

- Work directly on `master` for this simple project
- Test locally before pushing (open index.html in browser)
- GitHub Pages serves from `master` branch, `/` path

## Testing Checklist

Before pushing changes:

- [ ] Test in browser locally (open index.html)
- [ ] Try both Pokemon and MLP modes
- [ ] Toggle advanced mode on/off
- [ ] Complete at least one full round
- [ ] Check that preferences persist (reload page)
- [ ] Verify no console errors
- [ ] Test on mobile viewport if UI changes
- [ ] Ensure all sentences use valid characters (simple mode)

## Common Tasks

### Updating the Keyboard Diagram

The keyboard diagram in the HTML must accurately reflect real QWERTY layout with proper stagger offsets.

**CRITICAL - QWERTY Stagger Pattern**:

On a real QWERTY keyboard, rows stagger from LEFT to RIGHT as you go down:
```
Q W E R T Y U ...           ← Top row: 0px (leftmost)
  A S D F G H J K L ;       ← Home row: 18px (shift right)
    Z X C V B N M ,         ← Bottom row: 54px (shift more right)
```

**Correct padding values**:
- **QWERTY row (top)**: `0px` - leftmost position, NO padding
- **ASDF row (home)**: `18px` - shifted RIGHT by ~0.5 key width
- **ZXCV row (bottom)**: `54px` - shifted RIGHT by ~1.5 key widths

**Why this matters**:
- The ASDF row is NOT the baseline - the QWERTY row is!
- Rows shift RIGHT as you go down, creating the characteristic diagonal stagger
- E is above D, R above F, T above G - because home row is shifted right
- C is below D, V below F - because bottom row is shifted even more right

**Implementation**:
- Ghost keys (q, w, y, u, z, x, b, ;, ,) at `opacity: 0.2`
- Green (`.home`): Home row keys (a-l) where fingers rest
- Blue (`.used`): Allowed close keys (e, r, t, c, v, n, m)
- Faint gray: Context keys showing full QWERTY layout

**Common mistake to avoid**:
❌ Setting home row to 0 and shifting QWERTY/ZXCV rows left - this is backwards!
✅ QWERTY at 0, shift ASDF right, shift ZXCV even more right

**Critical**: When modifying the diagram:
1. QWERTY row MUST have 0 left padding (leftmost position)
2. Home row shifts RIGHT by ~18px (not left!)
3. Bottom row shifts even MORE right by ~54px
4. Include ghost keys at opacity 0.2 for spatial context
5. Verify against a real keyboard photo before committing

### Adding Pokemon Type Sentences

1. Find the type in `sentences` object (e.g., `psychic:`)
2. Add sentences using ONLY: `a s d f g h j k l e r t c v n m` + spaces
3. Vary lengths: some short (10-15), medium (20-30), long (30-40)
4. Match the type's theme

### Adding MLP Character Content

**Simple mode**: Add to existing theme arrays (e.g., `magic:`, `fast:`)
**Advanced mode**: Add to `*_advanced` arrays (e.g., `magic_advanced:`)

### Modifying UI Colors

Edit CSS variables in `:root`:
```css
--accent-yellow: #f5c518;  /* Main accent */
--accent-blue: #4cc9f0;    /* Secondary */
--correct: #06d6a0;        /* Correct char */
--error: #e94560;          /* Wrong char */
```

## Important Notes

- **Single file philosophy**: Keep everything in index.html
- **No dependencies**: Don't add npm, webpack, React, etc.
- **Accessibility**: Input field must stay focusable for keyboard use
- **Performance**: Minimize API calls, use retries, cache in localStorage if needed
- **Mobile**: Touch targets should be large enough (current design works)

## Future Enhancement Ideas

If user requests:
- Add more character modes (Digimon, Dragon Ball, etc.)
- Speed (WPM) tracking
- Sound effects toggle
- Dark/light theme toggle
- Difficulty presets (strict home row vs all keys)
- Multiplayer/competitive mode
- Custom sentence upload

Always confirm with user before adding major features.

## Resources

- [PokeAPI Docs](https://pokeapi.co/docs/v2)
- [Press Start 2P Font](https://fonts.google.com/specimen/Press+Start+2P)
- [JetBrains Mono Font](https://fonts.google.com/specimen/JetBrains+Mono)
- [GitHub Pages Docs](https://docs.github.com/en/pages)
