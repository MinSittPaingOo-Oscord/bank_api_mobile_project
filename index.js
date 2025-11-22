const express = require('express')
const cors = require('cors')
const mysql = require('mysql2')
require('dotenv').config()
const app = express()

app.use(cors())
app.use(express.json())

const connection = mysql.createConnection(process.env.DATABASE_URL)

app.get('/', (req, res) => {
    res.send('Hello world!!')
})

app.get('/deposit', (req, res) => {
    connection.query(
        'SELECT * FROM deposit',
        function (err, results, fields) {
            res.send(results)
        }
    )
})

app.get('/withdraw', (req, res) => {
    connection.query(
        'SELECT * FROM withdraw',
        function (err, results, fields) {
            res.send(results)
        }
    )
})

app.get('/balance', (req, res) => {
    connection.query(
        'SELECT * FROM balance WHERE balance.balanceID = 1',
        function (err, results, fields) {
            res.send(results)
        }
    )
})

app.post('/deposit', (req, res) => {
    const amount = req.body.amount;
    const today = new Date().toISOString().split('T')[0]; // Get today's date in YYYY-MM-DD format

    if (!amount || amount <= 0) {
        return res.status(400).send('Invalid amount');
    }

    // Insert the new deposit
    connection.query(
        'INSERT INTO `deposit` (`amount`, `date`) VALUES (?, ?)',
        [amount, today],
        function (err, results, fields) {
            if (err) {
                console.error('Error in POST /deposit:', err);
                return res.status(500).send('Error adding deposit');
            }

            // Update the balance
            connection.query(
                'UPDATE `balance` SET `balance` = `balance` + ? WHERE `balanceID` = 1',
                [amount],
                function (updateErr, updateResults, updateFields) {
                    if (updateErr) {
                        console.error('Error updating balance in POST /deposit:', updateErr);
                        return res.status(500).send('Error updating balance');
                    }

                    res.status(200).send(results); // Send the insert results (e.g., { insertId: X })
                }
            );
        }
    );
});

app.post('/withdraw', (req, res) => {
    const amount = req.body.amount;
    const today = new Date().toISOString().split('T')[0]; // Get today's date in YYYY-MM-DD format

    if (!amount || amount <= 0) {
        return res.status(400).send('Invalid amount');
    }

    connection.query(
        'INSERT INTO `withdraw` (`amount`, `date`) VALUES (?, ?)',
        [amount, today],
        function (err, results, fields) {
            if (err) {
                console.error('Error in POST /withdraw:', err);
                return res.status(500).send('Error withdrawing');
            }

            // Update the balance
            connection.query(
                'UPDATE `balance` SET `balance` = `balance` - ? WHERE `balanceID` = 1',
                [amount],
                function (updateErr, updateResults, updateFields) {
                    if (updateErr) {
                        console.error('Error updating balance in POST /withdraw:', updateErr);
                        return res.status(500).send('Error updating balance');
                    }

                    res.status(200).send(results); // Send the insert results (e.g., { insertId: X })
                }
            );
        }
    );
});


app.listen(process.env.PORT || 3000, () => {
    console.log('CORS-enabled web server listening on port 3000')
})

module.exports = app;

