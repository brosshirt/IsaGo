

// this function adds a number of minutes to a time string and returns a new time string
// so MWF-1335 and 10 output MWF-1345. It accounts for really long minute inputs so MWF-1335 and -1440 will give UTH-1335
function addToTimeString(timeString, minutes) {

    let scheduleComponents = timeString.split('-')
    let days = scheduleComponents[0]
    let time = scheduleComponents[1]
  
    let minutesPassed = timeToMinutes(time) + minutes 
  
    dayIncrement = 0
    while (minutesPassed < 0) {
      minutesPassed += 1440
      dayIncrement--
    }
    while (minutesPassed >= 1440) {
      minutesPassed -= 1440
      dayIncrement++
    }
    
    let newDays = addToDays(days, dayIncrement)
    let newTime = minutesToTime(minutesPassed)
  
    return `${newDays}-${newTime}`
  }
  
  function timeToMinutes(time) {
    const hours = time.substring(0, 2)
    const minutes = time.substring(2)
  
    return Number(hours) * 60 + Number(minutes)
  }
  
  function minutesToTime(minutes) {
      const hours = Math.floor(minutes / 60);
      const formattedHours = ('0' + hours).slice(-2);
      const formattedMinutes = ('0' + (minutes % 60)).slice(-2);
      return formattedHours + formattedMinutes;
  }
  
  function addToDays(days, increment) {
    let newDays = ""
    for (let i = 0; i < days.length; i++) {
      newDays += addToDay(days[i], increment)
    }
    return newDays
  }
  
  let days = ['M', 'T', 'W', 'H', 'F', 'S', 'U']
  
  function addToDay(day, increment) {
  
    increment = increment % 7
  
    for (let i = 0; i < days.length; i++) {
      if (days[i] == day) {
        newIndex = i + increment
        if (newIndex < 0) {
          newIndex += 7
        }
        else if (newIndex > 6) {
          newIndex -= 7
        }
        return days[newIndex]
      }
    }
  }
  
  
  
  



module.exports = {
    addToTimeString: addToTimeString
}
