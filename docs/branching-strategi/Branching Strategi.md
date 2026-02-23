
Who_Knows
/
Okay, Vi skal alve denne task: 
[DEVOPS]: Set up Git branching strategy and branch protection rules
### What needs to be done?
Define and implement a branching strategy for the team, and set up branch protection rules on GitHub so main is protected.
**Branching strategy:**
- Define naming convention for branches (e.g. feature/<issue-nr>-<description>, bugfix/<issue-nr>-<description>)
- Document workflow: branch from main -> work -> PR -> review -> merge
- Decide on squash merge, merge commit, or rebase
**Branch protection on main:**
- Require PR before merge (no direct push to main)
- Require at least 1 review/approval
- Require CI checks to pass before merge (depends on Sofie's CI setup)
- Consider: require branch to be up to date with main before merge
### Category
Repo setup
### Done when
- [ ] Branching strategy documented (in README or separate doc)
- [ ] Branch protection rules enabled on main in GitHub repo settings
- [ ] PR required before merge to main
- [ ] At least 1 approval required
- [ ] CI status checks required (once CI is in place)
- [ ] Team informed about the new strategy
### Additional Context
We're already using feature branches (e.g. feature/sobr-projektstruktur, feature/28-user-model). This task formalizes it and ensures main is always stable.
Coordinate with @sobr0002 Sofie since CI checks need to be set up before they can be required in branch protection.
Hvad tænker du ang. den først?
Show more
15.59

Analyserede eksisterende GitHub Flow-setup og forberedte konkret vejledning
Analyserede eksisterende GitHub Flow-setup og forberedte konkret vejledning
Godt issue, Andreas. Et par tanker:
I har allerede det meste på plads. Jeres CI pipeline kører (ci.yaml), I bruger feature branches med navnekonvention, og I har en branching-strategi-doc der venter på at blive udfyldt. Så det handler mest om at formalisere og dokumentere det I allerede gør.
Konkret anbefaling til branching strategi:
GitHub Flow er det rigtige valg for jer - I er tre personer, og Git Flow ville være overkill. Det betyder: main er altid deploybar, alt arbejde sker i feature branches, og alt kommer ind via PR med squash merge (holder historikken ren).
Navnekonvention som I allerede bruger fungerer fint: feature/<issue-nr>-<beskrivelse>, bugfix/<issue-nr>-<beskrivelse>. Behold den.
Branch protection - rækkefølge er vigtig:
Én ting at være opmærksom på: "Require at least 1 review/approval" kan blive en flaskehals for et 3-personers team. Hvis én er syg, skal de to andre stadig kunne merge. Overvej om 1 approval er nok, eller om I vil tillade at den der opretter PR'en selv kan merge efter CI er grøn (uden approval) som nødløsning. Det er en pragmatisk beslutning.
Desuden - "Require CI checks to pass" afhænger af at Sofies CI-setup er stabilt. I har build-test jobbet i ci.yaml allerede, så det burde være klar til at blive required. Bare sørg for at det er det præcise job-navn (build-test) I angiver som required status check i GitHub.
For selve tasken foreslår jeg denne rækkefølge:
Udfyld docs/branching-strategi/Branching Strategi.md med jeres beslutninger
Sæt branch protection rules op på GitHub (det er GUI-arbejde i repo settings)
Informer teamet
Vil du have mig til at skrive udkastet til branching-strategi-dokumentet?
hmm.... lige nu laver vi jo bare branches gennem GitHub, så de får jo bare issue nummer-TAG-hvad-tasken-hedder, vi kører jo ikke decideret bugfix/blabla eller feature/blabla
16.05

Acknowledged praktisk branch-naming convention over formaliseret workflow
Acknowledged praktisk branch-naming convention over formaliseret workflow
Det er en god pointe. Så jeres reelle workflow er: I opretter en branch direkte fra GitHub issue-siden, og den får automatisk navnet som f.eks. 42-devops-set-up-ci-pipeline. Ingen feature/ eller bugfix/ prefix.
Det er helt fint for et team på tre personer. Det vigtige er at det er konsistent og sporbart til et issue - og det er det allerede, fordi issue-nummeret er i branch-navnet.
Hvis I dokumenterer det, så skriv hvad I faktisk gør, ikke hvad der ser pænt ud i en lærebog. Det er også bedre til eksamen - I kan forklare hvorfor I valgte det simple approach fremfor Git Flow med prefixes.
Skal jeg skrive branching-strategi-dokumentet baseret på jeres faktiske workflow? Altså: GitHub Flow, branches oprettes fra issues (automatisk navngivning), squash merge, PR required, CI skal være grøn.
Men er det bedre så at køre en klassisk GitHub flow? med den navngivningskonvention
16.06

Vurderede fordele ved klassisk GitHub Flow-konvention
Vurderede fordele ved klassisk GitHub Flow-konvention
Begge dele fungerer. Men jeres nuværende approach er faktisk mere sporbar end klassisk GitHub Flow med prefixes, fordi:
Jeres nuværende: 42-devops-set-up-ci-pipeline - issue-nummeret er altid der, og GitHub linker automatisk branch til issue.
Klassisk GitHub Flow: feature/42-set-up-ci-pipeline - prefixet tilføjer information I allerede har via labels på issuet (devops, bug, feature osv.). Så prefixet er redundant.
Det eneste argument for prefixes er hvis I har brug for at filtrere branches visuelt i en lang liste. Med tre personer og kort-levende branches er det ikke et problem.
Min anbefaling: Behold det I gør. Dokumentér det som et bevidst valg med begrundelse - det er stærkere til eksamen end at kopiere en konvention I ikke har brug for. Noget i retning af: "Vi bruger GitHub's auto-genererede branch-navne fra issues, fordi issue-nummeret sikrer sporbarhed og labels erstatter behovet for prefixes."
Skal jeg skrive dokumentet ud fra det?
Vi behøver jo ikke bruge en predefineret strategi. Vi må gerne opfinde vores egen. 
Lige nu har vi main, development, branches I den rækkefølge. Spørgsmålet er, om vi skal have en branch udelukkende til tests?
16.07

Vurderede praktisk værdi af dedikeret testbranch mod kompleksitet
Vurderede praktisk værdi af dedikeret testbranch mod kompleksitet
Hvad ville en test-branch konkret gøre, som jeres CI ikke allerede gør?
I har ci.yaml der kører RuboCop og RSpec på hver PR til main og development. Så tests kører allerede automatisk før kode kan merges. En dedikeret test-branch ville bare være et ekstra step hvor den samme CI kører igen.
Jeres nuværende flow er reelt:
feature branch → PR til development (CI kører) → PR til main (CI kører)
Det giver jer allerede to checkpoints. En test-branch imellem ville være et tredje checkpoint der kører de samme tests - det tilføjer ventetid uden at fange noget nyt.
Hvor en test-branch kunne give mening er hvis I havde et separat test-suite der tager lang tid (integration tests, end-to-end tests) som I ikke vil køre på hver PR. Men det har I ikke lige nu, og med jeres projektskala er det usandsynligt.
Det korte svar: Nej. Tre personer, kort-levende branches, CI på PRs - en test-branch er overhead. Hvis I vil opfinde jeres egen strategi, er det stærkere at argumentere for hvorfor I fravalgte en test-branch end at tilføje den.
Vil du have mig til at skrive hele branching-dokumentet nu med jeres faktiske setup og begrundelser?
Så du tænker vi bare skal lade det være som det er?
16.08

Vurderede nuværende workflow og identificerede manglende formalisering
Vurderede nuværende workflow og identificerede manglende formalisering
Flowet er fint som det er. Men tasken handler jo også om at formalisere det - og der mangler stadig noget konkret:
Det I har: main → development → feature branches, CI på PRs. Det virker.
Det I mangler:
Selve branch protection rules på GitHub er ikke sat op endnu. Altså at main og muligvis development faktisk er beskyttet, så ingen kan pushe direkte. Det er det vigtigste deliverable i denne task.
Og så dokumentationen i docs/branching-strategi/Branching Strategi.md - den er tom lige nu med kun eksamensspørgsmål. Den skal udfyldes med hvad I gør og hvorfor.
Så planen er:
Sæt branch protection rules op i GitHub repo settings (kræver admin-adgang)
Udfyld branching-strategi-dokumentet med jeres faktiske workflow og begrundelser
Informér Sofie og Nima
Vil du starte med dokumentet, eller med at sætte protection rules op først?
lad os gå med branchprotection nu
16.09

Formulated konkret guide til branch protection opsætning
Formulated konkret guide til branch protection opsætning
Det er ren GitHub GUI-arbejde. Her er hvad du skal gøre:
Gå til: Repo → Settings → Branches → Add branch ruleset
For main:
Require a pull request before merging → slå til
Required approvals: 1
Require status checks to pass → slå til, og tilføj build-test (det er job-navnet fra jeres ci.yaml)
Block force pushes → slå til
Do not allow deletions → slå til
For development:
Samme regler, men overvej at sætte required approvals til 0 (altså PR required, men ingen approval nødvendig). Så kan I merge til development hurtigt, mens main forbliver strengt beskyttet. Det giver mening fordi development er jeres "staging" - main er production.
En ting at koordinere med Sofie: Status checket build-test skal have kørt mindst én gang på en PR før GitHub kan genkende det som et required check. Så sørg for at der er mindst én åben PR med CI-kørsel inden I slår det til.
Squash merge: Under Settings → General → Pull Requests kan I sætte "Allow squash merging" som standard og eventuelt slå de andre fra hvis I kun vil tillade squash.
Giv lyd når protection rules er sat op, så tager vi dokumentet bagefter.
hvad er forskellen på rules og branch protection rules?
'
16.10

Analyserede GitHub-funktioner for at skelne regler fra branch-beskyttelse
Analyserede GitHub-funktioner for at skelne regler fra branch-beskyttelse
GitHub har to systemer, og det kan være forvirrende:
Branch protection rules (det ældre system) findes under Settings → Branches → "Add branch protection rule". Det er det klassiske setup hvor du vælger en branch og sætter regler direkte på den. Simpelt og lige til.
Rulesets (det nyere system) findes under Settings → Rules → Rulesets. Det er GitHub's nyere approach hvor du kan lave mere fleksible regelsæt - f.eks. ét ruleset der gælder for flere branches, undtagelser for bestemte roller, osv.
For jer er forskellen ligegyldig. I har to branches der skal beskyttes (main og evt. development), tre teammedlemmer, ingen komplekse roller. Branch protection rules (det ældre system) er nemmere at sætte op og gør præcis det I har brug for.
Brug Settings → Branches → Add branch protection rule. Det er det mest dokumenterede og det I sandsynligvis finder flest guides til hvis noget driller.
Det er fikset nu og klar
16.38

Planlagde dokumentasjonsfase etter gjennomført branch-beskyttelse
Planlagde dokumentasjonsfase etter gjennomført branch-beskyttelse
Godt. Så mangler dokumentationen. Skal jeg skrive udkastet til docs/branching-strategi/Branching Strategi.md? Den er tom lige nu med kun eksamensspørgsmålene som skabelon.
Jeg skriver det baseret på jeres faktiske setup: main/development/feature branches, GitHub auto-genererede branch-navne fra issues, squash merge, PR required, CI som gate - og begrundelser for til- og fravalg.
ja, og gerne med alle de overvejelser vi har snakket om
16.39

Sammenfattede tidligere diskussioner for omfattende svar
Sammenfattede tidligere diskussioner for omfattende svar
Dokumentet dækker jeres faktiske workflow, alle de fravalg vi diskuterede (Git Flow, test-branch, prefixes), branch protection konfigurationen, og har to sektioner i bunden der kan opdateres løbende under kurset - det er godt til eksamen.
Erstat den eksisterende fil i docs/branching-strategi/Branching Strategi.md med denne. Vil du have PR-templaten udfyldt til dette issue?
Branching strategi
Document · MD 
#### Exam Requirement
- Pick a workflow and branching strategy 
- Pros and cons of the workflow and branching strategy
- Revise the document with new insights during the course
#### What version control strategy did you choose and how did you actually do it / enforce it?
#### Why did your group choose the one you did? Why did you not choose others?
#### What advantages and disadvantages did you run into during the course?
Det her er de spørgsmål vi ligesom har fået vi skal forhold os til. Det er også delvis mandatory 1 delen vi går ind og svare på her
16.41

Assessed exam requirements regarding version control strategies
Assessed exam requirements regarding version control strategies
Nu er dokumentet struktureret direkte efter eksamensspørgsmålene. Den sidste sektion er bevidst tom med pladsholdere - den udfylder I løbende under kurset som mandatory 1 kræver.
Skal vi tage PR-templaten til dette issue?
Branching strategi
Document · MD 
Det skal være på engelsk
16.42

Orchestrated document translation to English
Orchestrated document translation to English
Samme indhold, nu på engelsk. Skal vi tage PR-templaten til dette issue?
Branching strategi
Document · MD 
kan du lige forklare mig hvad der menes med squash merge?
16.51

Prepared concise explanation of squash merge concept
Prepared concise explanation of squash merge concept
Forestil dig du laver 5 commits på din feature branch:
fix typo
add login route
oops forgot semicolon
fix test
cleanup comments
Normal merge beholder alle 5 commits i historikken på main. Du kan se hele den rodede proces.
Squash merge samler alle 5 commits til én enkelt commit på main, f.eks.:
42 - Set up login route (#42)
Så på main ser det ud som om hele featuren blev lavet i én commit. Det er derfor historikken bliver ren - du ser én commit per issue/PR i stedet for alle de små "fix typo" og "oops" commits undervejs.
De originale commits eksisterer stadig på feature branchen indtil den slettes, men de når aldrig main.
hvordan gør man så det? jeg opretter jo bare en standard pr til den tid? Hvordan sikrer jeg det er et squash merge?
16.52

Undersøgte GitHub-indstillinger for squash merge-konfiguration
Undersøgte GitHub-indstillinger for squash merge-konfiguration
Der er to måder:
Per PR (manuelt): Når du trykker på den grønne "Merge pull request" knap på GitHub, er der en lille dropdown-pil ved siden af. Der kan du vælge mellem "Create a merge commit", "Squash and merge", og "Rebase and merge". Vælg "Squash and merge".
For hele repoet (anbefalet): Gå til Settings → General → scroll ned til "Pull Requests". Der kan du slå de andre merge-typer fra og kun beholde "Allow squash merging". Så er squash merge det eneste valg for alle PRs, og ingen kan vælge forkert ved et uheld.
Det sidste er nok det I bør gøre, så det er enforced og ikke noget man skal huske.
## What advantages and disadvantages did you run into during the course?
*(Updated continuously throughout the course)*
### Advantages experienced in practice
-
### Disadvantages experienced in practice
-
### What we would do differently next time
kan vi lige udfylde disse også?
17.15

Deliberated between assuming experiences versus soliciting authentic feedback directly
Deliberated between assuming experiences versus soliciting authentic feedback directly
Det afhænger af hvad I faktisk har oplevet. Jeg kan se fra jeres "Choices and Challenges" dokument at I har haft nogle konkrete erfaringer - f.eks. .gitignore konflikter der krævede at alle branches blev lukket, og database merge conflicts. Men er det branching-strategien der forårsagede det, eller ville det ske uanset strategi?
Lad mig spørge dig direkte: hvad har I oplevet som fungerede godt og hvad har været besværligt - specifikt i forhold til branching og merging?
Q: Hvilke af disse har I oplevet i praksis? (Select all that apply)
A: CI fangede fejl før merge (positivt), Merge conflicts mellem branches, Svært at holde development og main synkroniserede
Q: Har approval-kravet på main været et problem?
A: Nej, fungerer fint
17.16

Analyserede brugerens praktiske erfaringer med CI/CD-arbejdsgang
Analyserede brugerens praktiske erfaringer med CI/CD-arbejdsgang
Godt, så har jeg nok til at udfylde det. Kan du give mig et konkret eksempel eller to på merge conflicts I har haft? Jeg kan se fra jeres Choices and Challenges at .gitignore og database-filer var problematiske - var det de primære, eller har der været andre?
Og med "svært at holde development og main synkroniserede" - er det fordi development løber langt foran main, eller fordi der merges direkte til main ved en fejl?
det var de primære.
Og ja, det er fordi den er så langt foran
17.17

Forberedte dokumentopdatering med fordele og ulemper
Forberedte dokumentopdatering med fordele og ulemper
Det giver mening. Her er den opdaterede sektion:

Udfyldte dokument med erfaringsbaserede fordele og ulemper
Udfyldte dokument med erfaringsbaserede fordele og ulemper
"What we would do differently" sektionen foreslår to ting: hyppigere merges til main og korrekt .gitignore/db setup fra dag 1. Begge er baseret på jeres faktiske problemer. I kan stadig tilføje flere punkter løbende.
Skal vi tage PR-templaten?
Branching strategi
Document · MD 





Claude is AI and can make mistakes. Please double-check responses.
Branching strategi · MD
Copy

# Branching Strategy

**Written by:** Andreas, Nima & Sofie
**Updated:** February 23, 2026

---

## Exam Requirement

- Pick a workflow and branching strategy
- Pros and cons of the workflow and branching strategy
- Revise the document with new insights during the course

---

## What version control strategy did you choose and how did you actually do it / enforce it?

We use a customized GitHub Flow with a `development` layer:

```
main (production, always deployable)
  └── development (integration/staging)
        └── feature branches (created from GitHub issues)
```

The strategy is not a 1:1 copy of either GitHub Flow or Git Flow - it is tailored to our team size (3 people) and the project's needs.

### Branch hierarchy

**`main`** is always stable and deployable. No direct pushes are allowed. PRs require at least 1 approval and CI (RuboCop + RSpec) must pass before merge.

**`development`** serves as the integration branch where features are collected before going to main. PRs are required but no approval is needed - CI must still pass. It functions as staging.

**Feature branches** are created directly from GitHub issues via the "Create a branch" button. Naming is automatic: `<issue-nr>-<issue-title>`, e.g. `42-devops-set-up-ci-pipeline`. Branches are short-lived and deleted after merge.

### Naming convention

We do NOT use `feature/`, `bugfix/` or similar prefixes. The issue number in the branch name automatically provides traceability to the GitHub issue, and issue labels (`devops`, `bug`, `feature`, `rewrite`) replace the need for prefixes. With three team members and short-lived branches, there is no need to visually filter branches.

Examples of actual branch names: `28-user-model`, `42-devops-set-up-ci-pipeline`, `35-rewrite-login-register`.

### Merge strategy

We use squash merge for all PRs. All commits in a feature branch are condensed into a single commit upon merge. This provides a clean and readable Git history where each commit on main corresponds to one issue. Detailed commit history from the feature branch is lost, but a clean history is more valuable than granularity for a team of three.

### Branch protection rules (enforcement)

The strategy is enforced via GitHub branch protection rules:

**`main`:** Require PR before merge, 1 required approval, CI status check (`build-test`) required, force pushes blocked, deletion not allowed.

**`development`:** Require PR before merge, 0 required approvals, CI status check (`build-test`) required, force pushes blocked.

The difference in approval requirements is intentional: development should not be a bottleneck in daily work, while main is stricter because it represents production.

### Workflow (step by step)

1. Create issue on GitHub with relevant template and labels
2. Create branch from the issue (GitHub's "Create a branch" feature)
3. Work on the branch, commit regularly
4. Create PR to `development` when ready
5. CI runs automatically (RuboCop + RSpec)
6. Squash merge to development
7. When development is stable: PR from development to main
8. 1 approval + CI green → squash merge to main
9. Feature branch is deleted after merge

---

## Why did your group choose the one you did? Why did you not choose others?

### Why this strategy?

We are a team of three migrating a Flask application to Ruby/Sinatra. We needed something simple enough that we don't spend time on branch management, but structured enough that main is always stable. GitHub Flow with a development layer strikes that balance.

Branch names are generated automatically from GitHub issues, which provides traceability without extra conventions to remember. CI on all PRs ensures that no broken code reaches development or main.

### Why not Git Flow?

Git Flow uses `develop`, `release`, `hotfix` and `feature` branches with strict rules. It is designed for teams with formal release cycles and many parallel features.

We rejected it because we are three people, we have no formal releases (continuous deployment), and Git Flow would add overhead without benefit. Extra branch types like `release` and `hotfix` don't make sense when the team is small enough to coordinate directly.

### Why not a dedicated test branch?

We considered a separate branch solely for test runs. It was rejected because CI already runs automatically on all PRs to both development and main. A test branch would run the same tests a third time without catching anything new - it adds wait time and an extra manual step without added value. It would only make sense if we had heavy integration tests that shouldn't run on every PR, and we don't.

### Why not classic prefixes (feature/, bugfix/)?

Classic GitHub Flow typically uses `feature/`, `bugfix/` etc. as prefixes. We rejected this because GitHub's automatic branch names from issues already include the issue number, and labels on issues provide the same categorization as prefixes. Prefixes would be redundant information - traceability via issue number is stronger than traceability via prefix.

---

## What advantages and disadvantages did you run into during the course?

*(Updated continuously throughout the course)*

### Advantages experienced in practice

- CI as a gate on all PRs caught errors before they reached development or main. This gave us confidence that merged code was at least linted and tested, without relying on manual checks.
- The approval requirement on main has not been a bottleneck. With three people the turnaround on reviews is fast enough that it doesn't slow us down.
- Automatic branch names from issues made it easy to trace which branch belonged to which task without any extra effort.

### Disadvantages experienced in practice

- Merge conflicts were a recurring problem, particularly with .gitignore files and SQLite database files. The .gitignore conflict required us to close all active feature branches, consolidate into a single root-level .gitignore, and untrack files with `git rm --cached`. Database files are binary and cannot be merged - this was resolved by removing .db files from tracking entirely.
- Development runs far ahead of main. Because daily work merges into development and main only gets updated when development is considered stable, the gap between the two branches grows over time. This makes the eventual PR from development to main larger and harder to review, and increases the risk of unexpected issues when merging to production.

### What we would do differently next time

- Merge development into main more frequently. Smaller, more regular merges to main would reduce the gap and make each merge less risky. We could establish a cadence (e.g. weekly) or merge after each completed feature rather than waiting for multiple features to accumulate.
- Establish .gitignore and database tracking rules from day one. Both of our major merge conflict incidents could have been avoided with correct setup at the start of the project.
