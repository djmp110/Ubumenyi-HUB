// ---------- FORUM DATA (teachers & students interaction) ----------
    let forumTopics = [
        { id: 1, title: "📘 Doubt about quiz question #3 (Data Structures)", author: "Student_Aline", replies: 3, time: "2h ago", tags: "quiz-help" },
        { id: 2, title: "💡 Resource: Best practices for grading assignments", author: "Teacher_James", replies: 5, time: "5h ago", tags: "teacher-discussion" },
        { id: 3, title: "🧪 Can we have more role-specific coding challenges?", author: "Student_Elvis", replies: 2, time: "yesterday", tags: "feedback" }
    ];

    function renderForum() {
        const container = document.getElementById('forumTopicsContainer');
        if (!container) return;
        container.innerHTML = '';
        forumTopics.forEach(topic => {
            const topicDiv = document.createElement('div');
            topicDiv.className = 'forum-topic';
            topicDiv.innerHTML = `
                <div class="topic-title">
                    <span>${topic.title}</span>
                    <span class="badge-icon"><i class="fas fa-reply-all"></i> ${topic.replies}</span>
                </div>
                <div class="topic-meta">
                    <span><i class="fas fa-user-circle"></i> ${topic.author}</span>
                    <span><i class="fas fa-clock"></i> ${topic.time}</span>
                    <span><i class="fas fa-tag"></i> ${topic.tags}</span>
                </div>
                <button class="reply-btn" data-id="${topic.id}"><i class="fas fa-comment-dots"></i> Add reply</button>
            `;
            container.appendChild(topicDiv);
        });
        // attach reply events
        document.querySelectorAll('.reply-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const topicId = btn.getAttribute('data-id');
                alert(`💬 Reply feature: teachers & students can discuss! You replied to topic ID ${topicId}. (Simulated: real forum threads will appear here.)`);
            });
        });
    }

    // add new discussion post
    document.getElementById('addTopicBtn')?.addEventListener('click', () => {
        const inputEl = document.getElementById('newTopicTitle');
        const newTitle = inputEl.value.trim();
        if (!newTitle) {
            alert("Please write a discussion topic.");
            return;
        }
        const newTopic = {
            id: Date.now(),
            title: newTitle,
            author: "Current User",
            replies: 0,
            time: "just now",
            tags: "new"
        };
        forumTopics.unshift(newTopic);
        renderForum();
        inputEl.value = '';
        alert("✅ New discussion posted! Teachers & students can now reply.");
    });

    // ---------- ROLE-SPECIFIC QUIZ DATA (teacher vs student) ----------
    const quizzes = {
        student: {
            roleName: "Student",
            questions: [
                { text: "What is the primary purpose of a ‘for loop’ in programming?", options: ["Repeat code block", "Define a variable", "Create a function", "Import library"], correct: 0 },
                { text: "Which of these is a version control system?", options: ["Git", "Python", "React", "Docker"], correct: 0 },
                { text: "What does HTML stand for?", options: ["Hyper Text Markup Language", "High Tech Modern Language", "Home Tool Markup Link", "Hyperlink Text Management"], correct: 0 }
            ]
        },
        teacher: {
            roleName: "Educator",
            questions: [
                { text: "Which pedagogical approach best supports active learning in live sessions?", options: ["Lecture-only", "Interactive polls & breakout rooms", "Reading slides only", "Pre-recorded videos only"], correct: 1 },
                { text: "How often should formative assessments be given to track student progress?", options: ["Once per semester", "Weekly low-stakes quizzes", "Never", "Only final exam"], correct: 1 },
                { text: "What is a key benefit of discussion forums for teachers?", options: ["Monitor student misunderstandings", "Increase grading load", "Eliminate live sessions", "Reduce student engagement"], correct: 0 }
            ]
        }
    };

    let currentRole = "student";   // student or teacher
    let quizState = { student: null, teacher: null }; // store selected answers

    function initQuizState() {
        // initialize selected answers array for each role
        for (let role of ['student', 'teacher']) {
            if (!quizState[role]) {
                quizState[role] = new Array(quizzes[role].questions.length).fill(null);
            }
        }
    }

    function renderQuiz() {
        const container = document.getElementById('quizDynamicArea');
        if (!container) return;
        const quizData = quizzes[currentRole];
        const userAnswers = quizState[currentRole] || new Array(quizData.questions.length).fill(null);
        let html = `<div class="quiz-card"><h4><i class="fas fa-brain"></i> ${quizData.roleName} Quiz — verify your knowledge</h4>`;
        quizData.questions.forEach((q, idx) => {
            html += `<div class="quiz-question">${idx+1}. ${q.text}</div>`;
            q.options.forEach((opt, optIdx) => {
                const isChecked = (userAnswers[idx] === optIdx);
                html += `<label class="quiz-option">
                            <input type="radio" name="q${idx}" value="${optIdx}" ${isChecked ? 'checked' : ''}>
                            ${opt}
                         </label>`;
            });
        });
        html += `<button class="submit-quiz" id="submitQuizBtn">✅ Submit ${quizData.roleName} Quiz</button>
                 <div id="quizFeedbackMsg" class="quiz-feedback"></div></div>`;
        container.innerHTML = html;

        // attach radio change listeners to update quizState
        for (let i = 0; i < quizData.questions.length; i++) {
            const radios = document.querySelectorAll(`input[name="q${i}"]`);
            radios.forEach(radio => {
                radio.addEventListener('change', (e) => {
                    quizState[currentRole][i] = parseInt(e.target.value);
                });
            });
        }
        // submit listener
        const submitBtn = document.getElementById('submitQuizBtn');
        if (submitBtn) {
            submitBtn.addEventListener('click', () => evaluateQuiz());
        }
    }

    function evaluateQuiz() {
        const quizData = quizzes[currentRole];
        const answers = quizState[currentRole];
        let score = 0;
        for (let i = 0; i < quizData.questions.length; i++) {
            if (answers[i] !== null && answers[i] === quizData.questions[i].correct) {
                score++;
            }
        }
        const total = quizData.questions.length;
        const feedbackDiv = document.getElementById('quizFeedbackMsg');
        const percentage = Math.round((score/total)*100);
        if (score === total) {
            feedbackDiv.innerHTML = `<i class="fas fa-trophy" style="color:#e67e22;"></i> Excellent! ${score}/${total} correct. You mastered the ${currentRole} role content! 🎉`;
        } else {
            feedbackDiv.innerHTML = `<i class="fas fa-chalkboard"></i> You got ${score}/${total} correct. Review the topics and try again! ${currentRole === 'student' ? 'Ask teachers in forum!' : 'Great educators keep learning!'}`;
        }
        // extra: for teacher correct feedback to encourage interaction
        if (currentRole === 'teacher' && score === total) {
            feedbackDiv.innerHTML += `<br>✨ Perfect! You model continuous learning — your students thrive.`;
        }
    }

    // role switcher
    function setupRoleSwitcher() {
        const roleBtns = document.querySelectorAll('.role-btn');
        roleBtns.forEach(btn => {
            btn.addEventListener('click', (e) => {
                roleBtns.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                currentRole = btn.getAttribute('data-role');
                // ensure answers array exists for that role
                if (!quizState[currentRole]) {
                    quizState[currentRole] = new Array(quizzes[currentRole].questions.length).fill(null);
                }
                renderQuiz();
            });
        });
    }

    // ----- LIVE SESSION modal simulation -----
    const modal = document.getElementById('liveModal');
    const joinBtn = document.getElementById('joinLiveBtn');
    const closeSpan = document.querySelector('.close-modal');
    const closeModalBtn = document.getElementById('closeModalBtn');

    if (joinBtn) {
        joinBtn.addEventListener('click', () => {
            modal.style.display = 'flex';
        });
    }
    function closeModal() {
        modal.style.display = 'none';
    }
    if (closeSpan) closeSpan.addEventListener('click', closeModal);
    if (closeModalBtn) closeModalBtn.addEventListener('click', closeModal);
    window.addEventListener('click', (e) => {
        if (e.target === modal) closeModal();
    });

    // Optional: live banner update each 30 sec (simulate new session)
    setInterval(() => {
        const bannerText = document.querySelector('#liveBanner h3');
        if (bannerText && Math.random() > 0.6) {
            const sessions = ['🔴 LIVE: "Frontend Frameworks" with Ms. Diane', '🔴 LIVE: "Discussion Forum Q&A marathon"', '🔴 LIVE: "Role-quiz workshop: Students vs Teachers"'];
            const randomSession = sessions[Math.floor(Math.random() * sessions.length)];
            bannerText.innerHTML = `<i class="fas fa-video"></i> ${randomSession}`;
        }
    }, 15000);

    // initial calls
    renderForum();
    initQuizState();
    renderQuiz();
    setupRoleSwitcher();

    // Additional: simulate teacher-student interaction – if a forum reply mentions quiz, display dynamic note
    console.log("Online learning page ready: Live sessions, discussion forums, role quizzes active.");