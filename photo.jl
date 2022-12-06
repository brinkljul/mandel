# credit: https://gist.github.com/Wikunia/71b6577cc525f580898e87395ead5a73
# todo: figure out why i can't zoom past E10 (step == 0?)

using Colors, ColorSchemes
using GLMakie

# get the number of steps
function get_steps(c::Complex, max_steps)
    z = Complex(0.0, 0.0)
    for i=1:max_steps
        z = z*z+c
        if abs2(z) >= 4
            return i
        end
    end
    return 0
end

function mandelbrot_plot(max_steps, center_real, center_imag, zoom_factor)
    width = 1000
    height = 600
   
    # range for real values

    cr_min = center_real - zoom_factor
    cr_max = center_real + zoom_factor

    # range for imaginary values
    ci_min = center_imag - zoom_factor * height / width
    
    range = cr_max - cr_min
    dot_size = range/width
    ci_max = ci_min + height * dot_size

    complexes = zeros(ComplexF64, (height, width))
    steps = zeros(Int, (height, width))

    xs = cr_min:dot_size:cr_max-dot_size
    ys = ci_min:dot_size:ci_max-dot_size

    x, y = 1, 1
    for ci = ys
        x = 1
        for cr = xs
            complexes[y, x] = Complex(cr, ci)
            x += 1
        end
        y += 1
    end

    steps .= get_steps.(complexes, max_steps)

    scene = heatmap(xs, ys, rotr90(steps), colormap = :grays, colorrange = (0, max_steps), axis = (aspect = DataAspect(),))

    GLMakie.save("mandel.png", scene)
end

@time mandelbrot_plot(50, -0.68, 0.1, 1.0);