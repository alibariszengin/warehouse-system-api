const axios = require('axios');

const getDistanceFromMaps = async(from,to) =>{


    if(!(from && to)){
        return;
    }
    from.replace(" ","+");
    to.replace(" ","+");

    const {DISTANCE_API_KEY} = process.env;
    let dist;
    let durat;

    await axios.get(`https://maps.googleapis.com/maps/api/distancematrix/json?origins=${from}&destinations=${to}&key=${DISTANCE_API_KEY}`)
    .then(function (response) {
        console.log(response.data.rows[0].elements[0]);
        durat = response.data.rows[0].elements[0].duration.text;
        dist = response.data.rows[0].elements[0].distance.text;
      });
 
    return {
        success: true,
        distance:dist,
        duration :durat
    }


}

module.exports = {
    getDistanceFromMaps
}