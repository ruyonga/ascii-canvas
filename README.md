# Ascii Canvas

To start your Phoenix server:
    
  * Clone repository
  * Install dependencies with `mix deps.get`
  * Update the `config/dev.exs` with your database credentials.
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`
  * Using API tools  like ``insomnia or PostMan`` run the curl below providing the required parameters.
    
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# TASK

Implement REST API to generate Ascii art on a fixed size canvas at specified ``x, y``  position on with a specified length/width `w`, height `h` , border character `b` as `boarder`, and fill character `f` as `fill` and shape `s`

```
    - x: Integer - Horizontal positioning of the shape on canvas
    - y: Integer - Vertical positioning of the shape on canvas
    - w: Integer - length of the shape on the canvas. (Number of characters on horizontally boarder)
    - h: Integer - height  of the shape on the canvas. (Number of characters vertically)
    - f: String - Ascii character to print inside the shape
    - b: String - Ascii character to print the border od the shape
    - s: String - Shape to draw( currently supports oval, rectangle
```

# Request
- fill & boarder parameter are optional
- At least one of fill / boarder should be supplied 
- You create one or more shapes on the same canvas.
````
{
    	"images": [
    		{
    			"position": {
    				"x": 20,
    				"y": 20
    			},
    			"fill": "-",
    			"boarder": "@",
    			"length": 10,
    			"width": 10,
    			"shape": "rectangle"
    		},
    		{
    			"position": {
    				"x": 20,
    				"y": 40
    			},
    			"fill": "-",
    			"boarder": "@",
    			"length": 10,
    			"width": 10,
    			"shape": "rectangle"
    		}
    	]
    }
````
Curl

    curl --request POST \
      --url http://localhost:4000/api/images \
      --header 'content-type: application/json' \
      --data '{
    	"images": [
    		{
    			"position": {
    				"x": 20,
    				"y": 20
    			},
    			"fill": "-",
    			"boarder": "@",
    			"length": 10,
    			"width": 10,
    			"shape": "rectangle"
    		},
    		{
    			"position": {
    				"x": 20,
    				"y": 40
    			},
    			"fill": "-",
    			"boarder": "@",
    			"length": 10,
    			"width": 10,
    			"shape": "rectangle"
    		}
    	]
    }'


## Response
- Success: 
```
{
   "status": success,
   "message": "canvas generated successfully",
   "canva": {
         "id": "12et-3434-sds3-1234",
         "url": "http://localhost:4000/api/canvas/12et-3434-sds3-1234"
   }
}
```
- Error:
```
{
   "status": failed,
   "message": "Error generating canvas",
   "error": {
         "message": "Must suplly a fill or boarder value"
   }
}
```

## TEST
To view the produced results.
- Use the url in the response above to view download a `.png` of the canvas with the ascii printed matching the provided parameters