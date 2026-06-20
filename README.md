# Curve
A simple module made to cache bezier curve values for later use. It uses de Casteljau's algorithm to allow for any amount of bezier control points and to efficiently calculate the curve values

# API
The module only takes in variadics, so tables of Vector2 values should be unpacked using ```table.unpack``` whenever a Curve object is created
It is recommended you graph out your bezier curve using Desmos. The module does not support creating non-bezier curves at the moment

```
Curve.new(...: Vector2): {Vector2}
Curve.sample(x: number): Vector2
Curve.sample_parametric(t: number): Vector2
Curve.destroy(): ()
```

Creating a table
```
local vectors = {Vector2.new(0, 0), Vector2.new(10, 30), Vector2.new(17, 6)
local curve = Curve.new(table.unpack(vectors))
```

Sampling a curve
```local vec2 = curve.sample(12) -- input is any x value within the domain of your vectors array```

You can also sample a parametric curve
```local vec2 = curve.sample(0.7) -- input is a value between [0, 1], which corresponds with the beginning and end of your curve```

Destroying a curve
```
curve:destroy()
curve = nil
```
