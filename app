// Initial Values

const log = console.log;

// Selecting elements from the DOM
const searchButton = document.querySelector('#search');;
const searchInput = document.querySelector('#exampleInputEmail1');
const moviesContainer = document.querySelector('#movies-container');
const moviesSearchable = document.querySelector('#movies-searchable');
const inp=document.querySelector('sugg');
const videobg=document.querySelector('trailer');
document.getElementById("trailer").style.display="none";
function resetInput() {
    searchInput.value = '';
}

function handleGeneralError(error) {
    log('Error: ', error.message);
    alert(error.message || 'Internal Server');
}

function createIframe(video) {
    const videoKey = (video && video.key) || 'No key found!!!';
    const iframe = document.createElement('iframe');
    iframe.src = `http://www.youtube.com/embed/${videoKey}`;
    iframe.width = 360;
    iframe.height = 315;
    iframe.allowFullscreen = true;
    return iframe;
}

function insertIframeIntoContent(video, content) {
    const videoContent = document.createElement('div');
    const iframe = createIframe(video);

    videoContent.appendChild(iframe);
    content.appendChild(videoContent);
}


function createVideoTemplate(data) {
    const content = this.content;
    content.innerHTML = '<p id="content-close">X</p>';
    
    const videos = data.results || [];

    if (videos.length === 0) {
        content.innerHTML = `
            <p id="content-close">X</p>
            <p>No Trailer found for this video id of ${data.id}</p>
        `;
        return;
    }

    for (let i = 0; i < 4; i++) {
        const video = videos[i];
        insertIframeIntoContent(video, content);
    }
}

function createSectionHeader(title) {
    const header = document.createElement('h2');
    header.innerHTML = title;

    return header;
}


function renderMovies(data) {
    const moviesBlock = generateMoviesBlock(data);
    const header = createSectionHeader(this.title);
    moviesBlock.insertBefore(header, moviesBlock.firstChild);
    moviesContainer.appendChild(moviesBlock);
}

function renderSearchMovies1(data) {
    
    const movies = data.results;
    const suggestion = new Array();
        movies.forEach(function(item) {
           
            Object.keys(item).forEach(function(key) {
                if(key=="title"){
                 suggestion.push(item[key]);
             
                }
            });
          });
          var options = '';

          for (var i = 0; i < suggestion.length; i++) {
            options += '<option value="' + suggestion[i] + '" />';
          }
          
          document.getElementById('sugg').innerHTML = options;
 

   
}

function renderSearchMovies(data) {
    
    moviesSearchable.innerHTML = '';
    const moviesBlock = generateMoviesBlock(data);
    moviesSearchable.appendChild(moviesBlock);
   
}
var actorlist;

function createImageContainer(imageUrl,title,release_date,vote_average,overview ,id) {
  
    var str='<br><b>Actors: </b>';
    var str1='<br><br><br><b>Directors: </b>';
//  requestCast(url, searchActor, handleGeneralError);
var url='https://api.themoviedb.org/3/movie/'+id+'/credits?api_key=<api_key_here>&language=en-US';

        var xhttp = new XMLHttpRequest();
        var actors = new Array();
        var directors = new Array();
        
        xhttp.onreadystatechange = function() {
          
          

            if (this.readyState == 4 && this.status == 200) {
            var res=JSON.parse(xhttp.responseText);
            var cast=res["cast"];
       
           
    
            for(var i=0;i<cast.length;i++)
            {
                if(cast[i]["known_for_department"]=="Acting"){
               actors.push(cast[i]["name"]);
               str=str+cast[i]["name"]+",";
             
                }
                   
                   if(cast[i]["known_for_department"]=="Directing"){
                   directors.push(cast[i]["name"]);
                   str1=str1+cast[i]["name"]+",";
                   }
            }
            details=` <div  style="display: inline;">${str+str1}</div>`
            document.getElementById("details").innerHTML +=details;
            traibtbn=`<br><br><br><button  onclick="trailer(${id})" style="background-color: inherit;box-shadow: none; border: none;cursor: pointer;color:blue;text-decoration: underline;" >view trialer</button>`;
            document.getElementById("details").innerHTML +=traibtbn;
            }
              
                 
        };
        xhttp.open("GET", url, true);
        xhttp.send();
  
      console.log(actors);
      console.log( directors);
  
    const tempDiv = document.createElement('div');
    tempDiv.setAttribute('class', 'imageContainer');
    tempDiv.setAttribute('data-id', id);
    var d = new Date( release_date );
if ( !!d. valueOf() ) {
year = d. getFullYear();
}


    const movieElement = `
    <div style="width:30%;">
        <img src="${imageUrl}" alt="" data-movie-id="${id}">
        
        
        
        <h4 align="center">ratings: ${vote_average}</h4>
        </div>
        <div id="details" style="width:60%;">
        <h4>${title} (${year})</h4>
        <p><b>Description:</b> ${overview}</p>
        
        
        </div>
    `;
    tempDiv.innerHTML = movieElement;
   
    return tempDiv;
}
function trailer(id){
    console.log(id);
    var url="https://api.themoviedb.org/3/movie/"+id+"/videos?api_key=<api_key_here>&language=en-US"
console.log(url)
        var xhttp = new XMLHttpRequest();
      
        
        xhttp.onreadystatechange = function() {
          
          

            if (this.readyState == 4 && this.status == 200) {
            var res=JSON.parse(xhttp.responseText);
            var video=res["results"];
       
           
    
            for(var i=0;i<video.length;i++)
            {
               
                if(video[i]["key"] && video[i]["type"]=="Trailer" ){
              console.log("http://www.youtube.com/embed/"+video[i]["key"]);
              videourl="http://www.youtube.com/embed/"+video[i]["key"]+"?autoplay=1";
              
              ifra=`<iframe id:"trailervideo" src="${videourl}" width="600px" height="600px" style="margin-left:30%;opacity:1.0" allowFullScreen ></iframe>`;

              document.getElementById("trailer").innerHTML +=ifra;
                showTrailer();

             
                }
                   
                 
                   }
            }
           
            
               
        };
        xhttp.open("GET", url, true);
        xhttp.send();

}
function closeTrailer(){
    

    document.getElementById("trailer").style.display="none";


}
function showTrailer(){
    document.getElementById("trailer").style.display="block";

    
    }
function searchDirector(data){
    console.log(data);
    const cast = data.cast;
    
    const directors = new Array();
    for(var i=0;i<cast.length;i++)
    {
        
        if(cast[i]["known_for_department"]=="Directing")
        directors.push(cast[i]["name"]);
    }
   return directors;
}

function generateMoviesBlock(data) {
   
    const movies = data.results;
    const section = document.createElement('section');
    section.setAttribute('class', 'section');
    
    for (let i = 0; i <1; i++) {
        const { poster_path,title,release_date,vote_average,overview, id } = movies[i];

        if (poster_path) {
            const imageUrl = MOVIE_DB_IMAGE_ENDPOINT + poster_path;
    const vote_average1=vote_average/2;
   
  
    
            const imageContainer = createImageContainer(imageUrl,title,release_date,vote_average1,overview, id);
            section.appendChild(imageContainer);
        
        }
    }

    const movieSectionAndContent = createMovieContainer(section);
    return movieSectionAndContent;
}



// Inserting section before content element
function createMovieContainer(section) {
    const movieElement = document.createElement('div');
    movieElement.setAttribute('class', 'movie');

    const template = `
        <div class="content">
            <p id="content-close">X</p>
        </div>
    `;

    movieElement.innerHTML = template;
    movieElement.insertBefore(section, movieElement.firstChild);
    return movieElement;
}
function myFunction() {
    var input, filter, ul, li, a, i, txtValue;
    input = document.getElementById("exampleInputEmail1");
   
    filter = input.value.toUpperCase();
    if (filter) {
        searchMovie1(filter);
       }
   
}
searchButton.onclick = function (event) {
    event.preventDefault();
    const value = searchInput.value

   if (value) {
    
    searchMovie(value);
   }
    resetInput();
}

