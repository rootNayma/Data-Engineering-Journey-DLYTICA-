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


    def paginate(self, endpoint, page_param="page", per_page_param="limit",
                 start_page=1, per_page=100, data_key="data"):
        page = start_page
        while True:
            payload = self.get(endpoint, {page_param:page, per_page_param: per_page})
            records = payload.get(data_key, [])
            if not records:
                break
            for rec in records:
                yield rec
            page += 1

