-- 1. List each pair of actors that have worked together.
SELECT a1.actor_id, a1.first_name AS actor1_first_name, a1.last_name AS actor1_last_name,
       a2.actor_id, a2.first_name AS actor2_first_name, a2.last_name AS actor2_last_name
FROM actor AS a1
JOIN film_actor AS fa1 ON a1.actor_id = fa1.actor_id
JOIN film_actor AS fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id != fa2.actor_id
JOIN actor AS a2 ON fa2.actor_id = a2.actor_id
ORDER BY a1.actor_id, a2.actor_id;

-- 2. For each film, list actor that has acted in more films.
SELECT f.film_id, f.title, a.actor_id, a.first_name, a.last_name
FROM film AS f
JOIN film_actor AS fa ON f.film_id = fa.film_id
JOIN actor AS a ON fa.actor_id = a.actor_id
JOIN (
    SELECT fa.actor_id, COUNT(fa.film_id) AS film_count
    FROM film_actor AS fa
    GROUP BY fa.actor_id
) AS actor_count ON a.actor_id = actor_count.actor_id
WHERE actor_count.film_count = (
    SELECT MAX(film_count)
    FROM (
        SELECT fa.actor_id, COUNT(fa.film_id) AS film_count
        FROM film_actor AS fa
        GROUP BY fa.actor_id
    ) AS actor_count_per_film
    WHERE actor_count_per_film.film_count = actor_count.film_count
)
ORDER BY f.film_id;
