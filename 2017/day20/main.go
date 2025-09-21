package main

import (
	"bufio"
	"math"
	"os"
	"regexp"
	"strconv"
)

type Vec3 struct {
	X int
	Y int
	Z int
}

type Particle struct {
	Pos Vec3
	Vel Vec3
	Acc Vec3
}

func abs(x int) int {
	if x < 0 {
		return -x
	}

	return x
}

func simulate(particles []Particle, ticks int, collisions bool) []Particle {
	for range ticks {

		new_particles := []Particle{}

		for _, particle := range particles {
			new_vel := Vec3{
				particle.Vel.X + particle.Acc.X,
				particle.Vel.Y + particle.Acc.Y,
				particle.Vel.Z + particle.Acc.Z,
			}

			new_pos := Vec3{
				particle.Pos.X + new_vel.X,
				particle.Pos.Y + new_vel.Y,
				particle.Pos.Z + new_vel.Z,
			}

			new_particles = append(new_particles, Particle{
				Pos: new_pos,
				Vel: new_vel,
				Acc: particle.Acc,
			})
		}

		if collisions {
			intact_after_collision := []Particle{}

			for i, particle := range new_particles {
				collides := false

				for j := range new_particles {
					if i == j {
						continue
					}

					if new_particles[i].Pos.X == new_particles[j].Pos.X &&
						new_particles[i].Pos.Y == new_particles[j].Pos.Y &&
						new_particles[i].Pos.Z == new_particles[j].Pos.Z {
						collides = true
						break
					}
				}

				if !collides {
					intact_after_collision = append(intact_after_collision, particle)
				}
			}

			new_particles = intact_after_collision
		}

		particles = new_particles
	}

	return particles
}

func part1(particles []Particle) int {
	particles = simulate(particles, 1000, false)

	closest_id := 0
	min_dist := math.MaxInt32
	for id, particle := range particles {
		dist := abs(particle.Pos.X) + abs(particle.Pos.Y) + abs(particle.Pos.Z)
		if dist < min_dist {
			min_dist = int(dist)
			closest_id = id
		}
	}

	return closest_id
}

func part2(particles []Particle) int {
	return len(simulate(particles, 1000, true))
}

func main() {
	re, _ := regexp.Compile(`-?\d+`)
	scanner := bufio.NewScanner(os.Stdin)

	particles := []Particle{}
	for scanner.Scan() {
		matches := re.FindAllString(scanner.Text(), -1)
		numbers := []int{}

		for _, match := range matches {
			n, _ := strconv.Atoi(match)
			numbers = append(numbers, n)
		}

		particles = append(particles, Particle{
			Vec3{numbers[0], numbers[1], numbers[2]},
			Vec3{numbers[3], numbers[4], numbers[5]},
			Vec3{numbers[6], numbers[7], numbers[8]},
		})
	}

	println(part1(particles))
	println(part2(particles))
}
