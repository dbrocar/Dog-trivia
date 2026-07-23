<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>🐕 Dog Trivia Game</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Roboto, system-ui, sans-serif;
            background: linear-gradient(145deg, #f8f0e5 0%, #e6d5b8 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            margin: 0;
        }

        .app-container {
            max-width: 720px;
            width: 100%;
            background: rgba(255, 248, 235, 0.85);
            backdrop-filter: blur(8px);
            border-radius: 56px;
            box-shadow: 0 25px 50px -10px rgba(0, 0, 0, 0.3), inset 0 2px 4px rgba(255, 255, 200, 0.6);
            padding: 30px 28px 40px;
            border: 1px solid #f5e7d3;
            transition: all 0.2s;
        }

        h1 {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 2.4rem;
            font-weight: 700;
            color: #4b2e1a;
            letter-spacing: -0.5px;
            border-bottom: 3px dashed #ccb696;
            padding-bottom: 18px;
            margin-bottom: 24px;
        }

        h1 span {
            background: #d9b382;
            padding: 4px 16px;
            border-radius: 60px;
            font-size: 1.0rem;
            color: #2d1c0e;
            background: #efdcc7;
            margin-left: auto;
            font-weight: 600;
        }

        .stats {
            display: flex;
            justify-content: space-between;
            background: #dcc9b2;
            padding: 14px 22px;
            border-radius: 50px;
            margin-bottom: 30px;
            font-weight: 600;
            color: #2d1f12;
            box-shadow: inset 0 2px 6px rgba(90, 60, 30, 0.15);
        }

        .stats div {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .question-box {
            background: #fffcf3;
            border-radius: 40px;
            padding: 28px 24px;
            box-shadow: 0 8px 0 #bb9f82, 0 12px 28px -8px rgba(70, 40, 10, 0.2);
            margin-bottom: 30px;
        }

        .category-badge {
            display: inline-block;
            background: #a58362;
            color: #fcf3e6;
            font-size: 0.8rem;
            font-weight: 600;
            padding: 4px 16px;
            border-radius: 30px;
            letter-spacing: 0.3px;
            margin-bottom: 14px;
            text-transform: uppercase;
        }

        .question-text {
            font-size: 1.7rem;
            font-weight: 600;
            line-height: 1.3;
            color: #2e1d0e;
            word-break: break-word;
        }

        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin: 28px 0 18px;
        }

        .option-btn {
            background: #f6ede2;
            border: 2px solid #dac3ab;
            padding: 16px 10px;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: 500;
            color: #2d1b0b;
            cursor: pointer;
            transition: all 0.15s;
            box-shadow: 0 4px 0 #b3967a;
            text-align: center;
            word-break: break-word;
        }

        .option-btn:hover:not(:disabled) {
            background: #efe1cf;
            transform: scale(0.98);
        }

        .option-btn:active:not(:disabled) {
            transform: translateY(4px);
            box-shadow: none;
        }

        .option-btn.correct {
            background: #79b87a;
            border-color: #3d7a3e;
            color: white;
            box-shadow: 0 4px 0 #2d5f2e;
        }

        .option-btn.wrong {
            background: #d47b7b;
            border-color: #a14949;
            color: white;
            box-shadow: 0 4px 0 #7a3333;
        }

        .option-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: translateY(4px);
            box-shadow: none;
        }

        .feedback {
            min-height: 48px;
            font-size: 1.1rem;
            font-weight: 500;
            padding: 8px 8px 0;
            color: #3f2b18;
        }

        .action-bar {
            display: flex;
            justify-content: flex-end;
            gap: 16px;
            margin-top: 12px;
            flex-wrap: wrap;
        }

        .btn {
            background: #e6cfb8;
            border: none;
            padding: 12px 32px;
            border-radius: 60px;
            font-weight: 700;
            font-size: 1.2rem;
            color: #2b1b0e;
            box-shadow: 0 6px 0 #b4977a;
            cursor: pointer;
            transition: all 0.1s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #f5e3ce;
        }

        .btn:active {
            transform: translateY(6px);
            box-shadow: none;
        }

        .btn:disabled {
            opacity: 0.4;
            transform: translateY(4px);
            box-shadow: none;
            pointer-events: none;
        }

        .btn-primary {
            background: #c7a17a;
            color: #26190d;
            box-shadow: 0 6px 0 #8d6e50;
        }

        .btn-primary:active {
            box-shadow: none;
        }

        .restart-btn {
            background: #b7a187;
            box-shadow: 0 6px 0 #7d6852;
        }

        .footer {
            margin-top: 24px;
            text-align: right;
            font-size: 0.9rem;
            color: #5b4632;
            border-top: 1px solid #dac3ab;
            padding-top: 18px;
            display: flex;
            justify-content: space-between;
        }

        @media (max-width: 550px) {
            .app-container {
                padding: 20px 16px;
            }
            h1 {
                font-size: 1.8rem;
            }
            .options-grid {
                grid-template-columns: 1fr;
            }
            .question-text {
                font-size: 1.4rem;
            }
        }
    </style>
</head>
<body>
    <div class="app-container" id="app">
        <h1>
            🐾 Dog Trivia
            <span id="questionCounter">1/15</span>
        </h1>

        <div class="stats">
            <div>🎯 Score: <span id="scoreDisplay">0</span></div>
            <div>✅ <span id="correctCount">0</span> / ❌ <span id="wrongCount">0</span></div>
        </div>

        <div class="question-box">
            <div class="category-badge" id="categoryBadge">Mixed Breeds</div>
            <div class="question-text" id="questionText">Loading question...</div>
        </div>

        <div class="options-grid" id="optionsContainer">
            <button class="option-btn" data-index="0">-</button>
            <button class="option-btn" data-index="1">-</button>
            <button class="option-btn" data-index="2">-</button>
            <button class="option-btn" data-index="3">-</button>
        </div>

        <div class="feedback" id="feedbackMessage">🐕 Choose an answer above!</div>

        <div class="action-bar">
            <button class="btn restart-btn" id="restartBtn">⟳ New Game</button>
            <button class="btn btn-primary" id="nextBtn" disabled>Next ➜</button>
        </div>

        <div class="footer">
            <span>🐶 100% dog-approved</span>
            <span id="questionProgress">Q1</span>
        </div>
    </div>

    <script>
        (function() {
            // ---------- TRIVIA DATA (15 questions, all dog-related) ----------
            const QUESTIONS = [{
                category: "Breed Origins",
                question: "Which breed is known as the 'barkless dog' from Africa?",
                options: ["Basenji", "Shiba Inu", "Dingo", "Pharaoh Hound"],
                correct: 0
            }, {
                category: "Famous Dogs",
                question: "What was the name of the Toto's breed in The Wizard of Oz?",
                options: ["Cairn Terrier", "Yorkshire Terrier", "Westie", "Norwich Terrier"],
                correct: 0
            }, {
                category: "Health & Anatomy",
                question: "How many teeth do adult dogs typically have?",
                options: ["28", "32", "42", "48"],
                correct: 2
            }, {
                category: "Dog History",
                question: "The Greyhound is one of the oldest dog breeds. How fast can it run?",
                options: ["35 mph", "45 mph", "55 mph", "65 mph"],
                correct: 1
            }, {
                category: "Pop Culture",
                question: "Which cartoon dog is the pet of a pizza-loving teenager?",
                options: ["Snoopy", "Brian", "Goofy", "Odie"],
                correct: 3
            }, {
                category: "Breed Facts",
                question: "What is the heaviest dog breed on average?",
                options: ["Mastiff", "St. Bernard", "English Mastiff", "Newfoundland"],
                correct: 2
            }, {
                category: "Dog Senses",
                question: "Approximately how many olfactory receptors do dogs have?",
                options: ["50 million", "200 million", "300 million", "1 billion"],
                correct: 2
            }, {
                category: "Famous Dogs",
                question: "Which dog was the first to star in a Hollywood film?",
                options: ["Rin Tin Tin", "Lassie", "Toto", "Beethoven"],
                correct: 0
            }, {
                category: "Breed Groups",
                question: "Which group does the Poodle belong to (AKC)?",
                options: ["Toy", "Non-Sporting", "Working", "Herding"],
                correct: 1
            }, {
                category: "Dog Care",
                question: "What food is toxic to dogs?",
                options: ["Carrots", "Grapes", "Peanut Butter", "Pumpkin"],
                correct: 1
            }, {
                category: "Canine Behavior",
                question: "Why do dogs circle before lying down?",
                options: ["Territorial marking", "Instinct from ancestors", "Checking for fleas", "Stretching"],
                correct: 1
            }, {
                category: "World Records",
                question: "Which dog holds the record for the longest tongue?",
                options: ["Boxer", "St. Bernard", "Labrador", "Mastiff"],
                correct: 1
            }, {
                category: "Mixed Trivia",
                question: "What color is the tongue of a Chow Chow?",
                options: ["Pink", "Black", "Blue-black", "Spotted"],
                correct: 2
            }, {
                category: "Dog Sports",
                question: "Which sport involves dogs jumping into water to retrieve items?",
                options: ["Agility", "Flyball", "Dock Diving", "Lure Coursing"],
                correct: 2
            }, {
                category: "Breed Origins",
                question: "The Dalmatian is most known for its association with what?",
                options: ["Firehouses", "Circuses", "Police", "Hunting"],
                correct: 0
            }];

            // ---------- STATE ----------
            let currentQuestions = [];
            let currentIndex = 0;
            let score = 0;
            let correctCount = 0;
            let wrongCount = 0;
            let isAnswered = false;

            // DOM refs
            const questionText = document.getElementById('questionText');
            const categoryBadge = document.getElementById('categoryBadge');
            const optionsBtns = document.querySelectorAll('.option-btn');
            const feedback = document.getElementById('feedbackMessage');
            const nextBtn = document.getElementById('nextBtn');
            const restartBtn = document.getElementById('restartBtn');
            const scoreDisplay = document.getElementById('scoreDisplay');
            const correctCountSpan = document.getElementById('correctCount');
            const wrongCountSpan = document.getElementById('wrongCount');
            const questionCounter = document.getElementById('questionCounter');
            const questionProgress = document.getElementById('questionProgress');

            // ---------- HELPERS ----------
            function shuffleArray(arr) {
                for (let i = arr.length - 1; i > 0; i--) {
                    const j = Math.floor(Math.random() * (i + 1));
                    [arr[i], arr[j]] = [arr[j], arr[i]];
                }
                return arr;
            }

            // Shuffle the questions order for each game
            function initGame() {
                // deep copy & shuffle
                currentQuestions = shuffleArray([...QUESTIONS]);
                currentIndex = 0;
                score = 0;
                correctCount = 0;
                wrongCount = 0;
                isAnswered = false;
                updateStats();
                renderQuestion();
                nextBtn.disabled = true;
                // reset all option styles
                optionsBtns.forEach(btn => {
                    btn.disabled = false;
                    btn.className = 'option-btn';
                });
                feedback.textContent = '🐕 Choose an answer above!';
                questionCounter.textContent = `1/${currentQuestions.length}`;
            }

            function renderQuestion() {
                if (currentIndex >= currentQuestions.length) {
                    // GAME OVER
                    questionText.textContent = '🎉 You finished all questions! 🎉';
                    categoryBadge.textContent = '🏁 Game Over';
                    optionsBtns.forEach(btn => {
                        btn.disabled = true;
                        btn.textContent = '—';
                        btn.className = 'option-btn';
                    });
                    feedback.innerHTML = `🐶 <strong>Final Score: ${score} / ${currentQuestions.length}</strong> — Great job!`;
                    nextBtn.disabled = true;
                    questionCounter.textContent = `${currentQuestions.length}/${currentQuestions.length}`;
                    questionProgress.textContent = '🏁 Done';
                    return;
                }

                const q = currentQuestions[currentIndex];
                categoryBadge.textContent = q.category;
                questionText.textContent = q.question;
                questionCounter.textContent = `${currentIndex + 1}/${currentQuestions.length}`;
                questionProgress.textContent = `Q${currentIndex + 1}`;

                // set option texts
                q.options.forEach((opt, idx) => {
                    optionsBtns[idx].textContent = opt;
                    optionsBtns[idx].disabled = false;
                    optionsBtns[idx].className = 'option-btn';
                });

                // reset feedback
                feedback.textContent = '🤔 Pick an option!';
                isAnswered = false;
                nextBtn.disabled = true;

                // enable buttons
                optionsBtns.forEach(btn => btn.disabled = false);
            }

            function updateStats() {
                scoreDisplay.textContent = score;
                correctCountSpan.textContent = correctCount;
                wrongCountSpan.textContent = wrongCount;
            }

            // ---------- HANDLE ANSWER ----------
            function handleOptionClick(e) {
                const btn = e.currentTarget;
                if (btn.disabled || isAnswered) return;

                const selectedIndex = parseInt(btn.dataset.index, 10);
                const q = currentQuestions[currentIndex];
                const isCorrect = (selectedIndex === q.correct);

                // mark answered
                isAnswered = true;
                nextBtn.disabled = false;

                // disable all option buttons
                optionsBtns.forEach(b => b.disabled = true);

                // highlight correct / wrong
                optionsBtns.forEach((b, idx) => {
                    if (idx === q.correct) {
                        b.classList.add('correct');
                    } else if (idx === selectedIndex && !isCorrect) {
                        b.classList.add('wrong');
                    }
                });

                // update score & counts
                if (isCorrect) {
                    score += 1;
                    correctCount += 1;
                    feedback.innerHTML = '✅ <strong>Correct!</strong> Well done! 🐾';
                } else {
                    wrongCount += 1;
                    const correctAnswer = q.options[q.correct];
                    feedback.innerHTML = `❌ <strong>Oops!</strong> The correct answer was: “${correctAnswer}”`;
                }

                updateStats();
            }

            // ---------- NEXT QUESTION ----------
            function goToNext() {
                if (nextBtn.disabled) return;

                currentIndex++;
                if (currentIndex < currentQuestions.length) {
                    renderQuestion();
                    // re-enable buttons (renderQuestion disables then re-enables)
                } else {
                    // game over state
                    renderQuestion(); // triggers game-over screen
                    optionsBtns.forEach(btn => btn.disabled = true);
                    nextBtn.disabled = true;
                }
            }

            // ---------- RESTART ----------
            function restartGame() {
                initGame();
                // reset visual
                optionsBtns.forEach(btn => btn.className = 'option-btn');
                feedback.textContent = '🐕 New game started!';
                nextBtn.disabled = true;
                questionProgress.textContent = 'Q1';
            }

            // ---------- ATTACH EVENTS ----------
            optionsBtns.forEach(btn => {
                btn.addEventListener('click', handleOptionClick);
            });

            nextBtn.addEventListener('click', goToNext);
            restartBtn.addEventListener('click', restartGame);

            // ---------- START ----------
            initGame();
        })();
    </script>
</body>
</html>
