
        var netsalary;
        
        for(var i = 0; i < 10; i++) {
            // Get user input
            var workername = prompt("Enter your name ");
            var job = prompt("Enter your job");
            var tax = prompt("Enter tax rate ");
            var grossSalary = parseFloat(prompt("Enter your salary: "));
            
            // Create a new card div
            var card = document.createElement('div');
            card.className = 'card';
            
            // Build content for this card with better formatting
            var content = "";
            content += "<h3 style='margin-top:0; color: #fff;'>Employee " + (i+1) + "</h3>";
            content += "<hr style='border-color: rgba(159, 241, 131, 0.3);'>";
            content += "<strong>Name:</strong> " + workername + "<br><br>";
            content += "<strong>Job:</strong> " + job + "<br><br>";
            content += "<strong>Monthly Salary:</strong> " + grossSalary + " Rwf<br><br>";
            
            if(grossSalary < 70000) {
                content += "<span style='color: #90EE90;'> You will not give tax</span><br>";
            } else {
                content += "<span style='color: #FF6B6B;'> You will give tax</span><br>";
                netsalary = grossSalary - (grossSalary * tax);
                content += "<strong>Net Salary:</strong> " + netsalary.toFixed(2) + " Rwf<br>";
            }
            
            // Add content to card
            card.innerHTML = content;
            
            // Add card to container
            document.getElementById('cards-container').appendChild(card);
        }