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

function mandelbrot_plot(max_steps, center_real, center_imag, zoom_factor, speed)
    width = 1000
    height = 600

    cr_min = center_real - zoom_factor
    cr_max = center_real + zoom_factor

    # range for imaginary values
    ci_min = center_imag - zoom_factor * height / width
    
    rangecr = cr_max - cr_min
    dot_size = rangecr/width
    ci_max = ci_min + height * dot_size

    xs = cr_min:dot_size:cr_max-dot_size
    ys = ci_min:dot_size:ci_max-dot_size
    steps = zeros(Int, (height, width))
    fig, ax, hm = heatmap(xs, ys, rotr90(steps), colormap = :inferno, colorrange = (0, max_steps), axis = (aspect = DataAspect(),))

    GLMakie.record(fig, "mandel.mp4", 1:speed:speed*50) do i
        zoom_factor *= (1 - 0.02 * speed)
        max_steps += speed * 20

        cr_min = center_real - zoom_factor
        cr_max = center_real + zoom_factor

        # range for imaginary values
        ci_min = center_imag - zoom_factor * height / width
        
        rangecr = cr_max - cr_min
        dot_size = rangecr/width
        ci_max = ci_min + height * dot_size

        xs = LinRange(cr_min, cr_max-dot_size, width)
        ys = LinRange(ci_min, ci_max-dot_size, height)

        complexes = zeros(ComplexF64, (height, width))
        steps = zeros(Int, (height, width))

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

        hm[1] = xs
        hm[2] = ys
        hm[3] = rotr90(steps)

        autolimits!(ax)
    end
end



mandelbrot_plot(50, big"-0.76977406013629035931268075596025004", big"-0.1000000032900403214794350534969786", 1.0, 3.0)