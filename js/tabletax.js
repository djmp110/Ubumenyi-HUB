 var tax = 0.23;
    var tbody = document.getElementById("tax");
    var rows = "";
    var numemlpoyee = prompt("Enter number of employee")

    for (var i = 0; i < numemlpoyee; i++) {

        var workername = prompt("Enter employee name:");
        var job = prompt("Enter employee job:");
        var grossSalary = parseFloat(prompt("Enter employee salary:"));

        var taxallow;
        var netsalary;

        if (grossSalary < 70000) {
            taxallow = "No";
            netsalary = grossSalary;
        } else {
            taxallow = "Yes";
            netsalary = grossSalary - (grossSalary * tax);
        }

        rows += `
            <tr>
                <td>${i + 1}</td>
                <td>${workername}</td>
                <td>${job}</td>
                <td>${grossSalary.toFixed(2)} Rwf</td>
                <td>${taxallow}</td>
                <td>${netsalary.toFixed(2)} Rwf</td>
            </tr>
        `;
        tbody = rows;
    }