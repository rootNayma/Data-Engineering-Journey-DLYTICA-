# Purpose of This File
# This is the API extractor.
# Its job: talk to REST APIs, handle retries, respect rate limits, and support pagination.

# 1. Talk to REST APIs
# The class knows how to make HTTP requests (GET) to a web API.
# Example: calling https://api.spacexdata.com/v4/launches?page=2.
# It attaches the authentication token (Authorization: Bearer …) so the API accepts the request.

# 2. Handle retries
# Sometimes APIs fail: maybe a timeout, maybe the server is busy.
# Instead of giving up immediately, this client will retry automatically.
# With tenacity, it retries up to 5 times, each time waiting longer (exponential backoff).

# 3. Respect rate limits
# APIs often say: “You can only call me 100 times per minute.”
# If you go too fast, they block you.
# _throttle() ensures we wait between calls so we don’t break the rules.

# 4. Support pagination
# APIs usually don’t send all data at once (too big).
# Instead: “Page 1 = first 100 records, Page 2 = next 100, …”
# The paginate() method keeps fetching page after page until there’s no more data.
# It uses yield so you can process records one by one without loading everything into memory.



import time, logging, requests                                                  # time → used for throttling (spacing out requests).
                                                                                # logging → logs what’s happening.
                                                                                # requests → standard HTTP client in Python.
                                                                                # tenacity → library that adds retry logic (with exponential backoff).
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type


log = logging.getLogger(__name__)                                               # → creates a logger object named after the file/module
                                                                                # so you can send messages (log.info(), log.error()) that show where they came from.


class ApiClient:                                                                # as we know here we are creating a class called ApiClient.

    def __init__(self, base_url: str, token: str, rate_limit_per_sec: float = 5.0):   # base_url → the main API address as (string)
                                                                                      # token → secret key for authentication as (string)
                                                                                      # rate_limit → how many requests you’re allowed as float 5.0 sec

                                                                                      # also just to reminde, we used :str, :float
                                                                                      # beacause to make our code readable for others too
                                                                                      # we can just do (base_url, token, rate_limit_per_sec=5.0):
                                                                                      # which will absoulety work too.


        self.base = base_url.strip("/")                                         # .strip = will remove. what ?? it will remove "/" slash
                                                                                # why because we need clean url like (api.xyz.com)
                                                                                # If base URL ends with / → "https://api.xyz.com//users" (double slash) → may cause errors.
                                                                                # self.base is storing clean base url

        self.session = requests.session()                                       # requests is library
                                                                                # Every time we ask the API for data, Python has to open a connection with server.
                                                                                # If we do requests.get(...) every time without a session
                                                                                # we have to do everything manually from the beginning
                                                                                # so, to resolve that and to make it automatic
                                                                                # we do requests.session(), bascilly its job is to remember

        self.session.headers.update({"Authorization": f"Bearer {token}"})       # so, here the requests.session is from the upper code which is inside self.session
                                                                                # and we are calling it here with.headers.update
                                                                                # .headers → where we can put extra info the API needs (like our token for authentication).
                                                                                # .update({...}) → works like a patcher/attacher adds new key-value pairs to the headers dictionary like {"Authorization": f"Bearer {token}"}

        self.min_interval = 1 / rate_limit_per_sec                              # rate_limit_per_sec = 5
                                                                                # self.min_interval = 1 / 5 = 0.2 seconds
                                                                                # This means: wait at least 0.2 seconds between each API call so we don’t exceed the limit.

        self.last = 0.0                                                         # self.last keeps track of when the last API request was made
                                                                                # starts at 0.0 because no request has been made yet


    def _throttle(self):                                                        # "_....." here _throttle is a private method
                                                                                # The goal of _throttle() is: make sure we don’t send API requests faster than the rate limit.
        elapsed = time.time() - self._last                                      # elapsed tells us how many seconds have passed since the last API request.
                                                                                # We use it to decide whether we need to wait before sending the next request.


        if elapsed > self.min_interval:                                         # elapsed < min_interval → we must wait (sleep) before making the next request.
                                                                                # elapsed >= min_interval → it’s safe to make the request immediately.



            time.sleep(self.min_interval - elapsed)                             # .sleep = tells do nothing
                                                                                # suppose min_interval = 5 and elasped = 3
                                                                                # .sleep = 5-3 = 2 sec
                                                                                #.sleep = for 2 sec please do nothing.

        self.last = time.time()                                                 # here we just update the last variable.


    @retry(stop=stop_after_attempt(5),                                          # retry is tenacity library to automatically retry the get() function if something goes wrong.
                                                                                # stop_after_apptemt (5) = as like the synatx it stops after 5 attempt
                
           wait=wait_exponential(min=1, max=30),                                # wait_exponential(min=1, max=30) = it will wait for 30 secs
                                                                                # exponetial = it will double 
           
                                                                                # | Attempt | Wait time (seconds) |
                                                                                # | ------- | ------------------- |
                                                                                # | 1       | 1                   |
                                                                                # | 2       | 2                   |
                                                                                # | 3       | 4                   |
                                                                                # | 4       | 8                   |
                                                                                # | 5       | 16 (but max 30)     |
 
           retry=retry_if_exception_type((requests.Timeout, requests.ConnectionError)),   
                                                                                # retry_if=  Only retry if these specific exceptions occur:
                                                                                # requests.Timeout → server took too long
                                                                                # requests.ConnectionError → network problem
                                                                                # Other errors (like 404 Not Found) won’t retry
           
           reraise=True)                                                        # After the final attempt, if it still fails → raise the exception so your program knows the request failed




    def get(self, path, param):                                                 # here we are just defining what we need
        self._throttle()                                                        # it is calling the upper throttle code
        
        r = self.session.get(f"{self.base}/{path.lstrip('/')}", params = params, timeout=30 )    # here we are requesting by get ( )
                                                                                # self.base = it is where the url is located
                                                                                # path = it is where the "lauches" is located
                                                                                # params = page like /page=1 
                                                                                # timeout = is time for 30 sec
                                                                                
        r.raise_for_status()                                                    # .raise is for any error exceeds the requests
        return r.json()                                                         # .json() = will just convert json fromate into python dict


    def paginate(self, endpoint, page_param="page", per_page_param="limit",     # here we are making a paginate func, think it as of www.api.exapmple/"page=1"
                 start_page=1, per_page=100, data_key="data"):                  # "page " is where the paginate will do its operation

                                                                                # endpoint = where to get data from 
                                                                                # page_param = how to tell the API which page you want
                                                                                # it is when you click next page in websites its shows url like www.api.example/page=2
                                                                                # per_page_param = how to tell the API how many items per page, 
                                                                                # per_page = how many items I want per page
                                                                                
                                                                                # per_page_param/ per_page is like a key and value
                                                                                # per_page_param is key and per _page is value
                                                                                # per_page_param = limit and per_page = 100
                                                                                # so, key=value, limit=100


                                                                                # start_page = which page to start from
                                                                                # If you already fetched page 1, you could start at page 2: start_page=2

                                                                                # data_key="data" = Where the actual list of items is in the API response.
                                                                                # {"data": [{"id":1,"name":"Alice"}, {"id":2,"name":"Bob"}]}
                                                                                # "data" is the key that holds the records.


        page = start_page                                                       # We’re starting from the first page (usually 1).
                                                                                # page keeps track of which page we are currently fetching.

        while True:                                                             # This creates an infinite loop, but don’t worry — there’s a break inside to stop it.
                                                                                # We use this because we don’t know in advance how many pages there are

            payload = self.get(endpoint, {page_param:page, per_page_param: per_page})
                                                                                # Sends query parameters to the API:
                                                                                # if endpoint="launches", page_param="page", per_page_param="limit", page=1, per_page=100:
                                                                                # GET https://api.example.com/launches?page=1&limit=100

            records = payload.get(data_key, [])                                 # Extracts the list of items from the response.

            if not records:                                                     # If the page is empty (no more data), stop the loop.      
                break                                                           # This prevents the infinite loop from going forever.

                                                                                
                                                                               

            for rec in records:                                                 # yield is like return, but instead of stopping the function completely, it pauses it and gives back a value.
                                                                                # The next time you call the function, it resumes from where it left off.  
                yield rec                                                       # If you have a lot of data (like thousands of API records), you don’t want to load everything into memory at once.

                       


            page += 1                                                           # Moves to the next page.
                                                                                # On next iteration, API will get page=2, then page=3, and so on until no records lef
  
