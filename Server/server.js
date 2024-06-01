const express = require('express')
const mongoose = require('mongoose')
var app = express()
var Data = require('./noteSchema')

mongoose.connect("mongodb://localhost/newDB")

mongoose.connection.once("open", () => {
    console.log("Connected to DB!")
}).on("error", (error) => {
    console.log("Failed to connect " + error)
})

// CREATE NOTE
// POST request
app.post("/create", (req, res) => {

    var note = new Data ({
        note: req.get("note"),
        title: req.get("title"),
        date: req.get("date")
    })

    note.save().then(() => {
        if (note.isNew == false) {
            console.log("Saved data!")
            res.send("Saved data!")
        } else {
            console.log("Failed to save data")
        }
    })
})

// http://<YourIPAddress>:8081/create
var IPAddress = "<Your IP Address>"
var server = app.listen(8081, IPAddress, () => {
    console.log("Server is running!")
})

// FETCH ALL NOTES
// GET request
app.get('/fetch', (req, res) => {
    Data.find({}).then((DBitems) => {
        res.send(DBitems)
    })
})

// DELETE NOTE
// POST request
// app.post('/delete', (req, res) => {
//     // Data.findOneAndRemove({
//         Data.deleteOne({
//         _id: req.get("id")
//         // _id: req.body.id
//     }, (err) => {
//         console.log("Failed" + err)
//     })

//     res.send("Deleted!")
// })
app.post('/delete', (req, res) => {
    Data.deleteOne({ _id: req.get("id") })
        .then(() => {
            res.send("Deleted!");
        })
        .catch((err) => {
            console.error("Failed: " + err);
            res.status(500).send("Failed to delete the record.");
        });
});

// UPDATE NOTE
// POST request

// app.post('/update', (req, res) => {
//     Data.findOneAndUpdate({
//         _id: req.get("id")
//     }, {
//         note: req.get("note"),
//         title: req.get("title"),
//         date: req.get("date")
//     }, (err) => {
//         console.log("Failed to update" + err)
//     })
//     res.send("Updated!")
// })

app.post('/update', (req, res) => {
    Data.findOneAndUpdate(
        { _id: req.get("id") },
        {
            note: req.get("note"),
            title: req.get("title"),
            date: req.get("date")
        }
    ).then(() => {
        res.send("Updated!");
    }).catch((err) => {
        console.error("Failed to update: " + err);
        res.status(500).send("Failed to update the record.");
    });
});
