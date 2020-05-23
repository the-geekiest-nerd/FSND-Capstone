--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-24 02:24:00

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2851 (class 1262 OID 17273)
-- Name: capstone_test; Type: DATABASE; Schema: -; Owner: postgres
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 207 (class 1259 OID 17298)
-- Name: actor_in_movie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actor_in_movie (
    actor_id integer NOT NULL,
    movie_id integer NOT NULL
);


ALTER TABLE public.actor_in_movie OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 17281)
-- Name: actors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actors (
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    full_name character varying(512) NOT NULL,
    date_of_birth date NOT NULL
);


ALTER TABLE public.actors OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 17279)
-- Name: actors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.actors_id_seq OWNER TO postgres;

--
-- TOC entry 2852 (class 0 OID 0)
-- Dependencies: 203
-- Name: actors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actors_id_seq OWNED BY public.actors.id;


--
-- TOC entry 202 (class 1259 OID 17274)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 17292)
-- Name: movies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movies (
    id integer NOT NULL,
    title character varying(256) NOT NULL,
    release_year integer NOT NULL,
    duration integer NOT NULL,
    imdb_rating double precision NOT NULL
);


ALTER TABLE public.movies OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 17290)
-- Name: movies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movies_id_seq OWNER TO postgres;

--
-- TOC entry 2853 (class 0 OID 0)
-- Dependencies: 205
-- Name: movies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movies_id_seq OWNED BY public.movies.id;


--
-- TOC entry 2702 (class 2604 OID 17284)
-- Name: actors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actors ALTER COLUMN id SET DEFAULT nextval('public.actors_id_seq'::regclass);


--
-- TOC entry 2703 (class 2604 OID 17295)
-- Name: movies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);


--
-- TOC entry 2845 (class 0 OID 17298)
-- Dependencies: 207
-- Data for Name: actor_in_movie; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2842 (class 0 OID 17281)
-- Dependencies: 204
-- Data for Name: actors; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2840 (class 0 OID 17274)
-- Dependencies: 202
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.alembic_version VALUES ('0f87e8f45ce0');


--
-- TOC entry 2844 (class 0 OID 17292)
-- Dependencies: 206
-- Data for Name: movies; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2854 (class 0 OID 0)
-- Dependencies: 203
-- Name: actors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actors_id_seq', 1, false);


--
-- TOC entry 2855 (class 0 OID 0)
-- Dependencies: 205
-- Name: movies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movies_id_seq', 1, false);


--
-- TOC entry 2711 (class 2606 OID 17302)
-- Name: actor_in_movie actor_in_movie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor_in_movie
    ADD CONSTRAINT actor_in_movie_pkey PRIMARY KEY (actor_id, movie_id);


--
-- TOC entry 2707 (class 2606 OID 17289)
-- Name: actors actors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actors
    ADD CONSTRAINT actors_pkey PRIMARY KEY (id);


--
-- TOC entry 2705 (class 2606 OID 17278)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 2709 (class 2606 OID 17297)
-- Name: movies movies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- TOC entry 2712 (class 2606 OID 17303)
-- Name: actor_in_movie actor_in_movie_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor_in_movie
    ADD CONSTRAINT actor_in_movie_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.actors(id);


--
-- TOC entry 2713 (class 2606 OID 17308)
-- Name: actor_in_movie actor_in_movie_movie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor_in_movie
    ADD CONSTRAINT actor_in_movie_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id);



INSERT INTO public.actors(name, full_name, date_of_birth) VALUES('Anne Hathaway', 'Anne Jacqueline Hathaway', 'November 12, 1982');
INSERT INTO public.actors(name, full_name, date_of_birth) VALUES('Matthew McConaughey', 'Matthew David McConaughey', 'November 4, 1969');
INSERT INTO public.actors(name, full_name, date_of_birth) VALUES('Margot Robbie', 'Margot Elise Robbie', 'July 2, 1990');
INSERT INTO public.actors(name, full_name, date_of_birth) VALUES('Mary Elizabeth Winstead', 'Mary Elizabeth Winstead', 'November 28, 1984');


INSERT INTO public.movies(title, release_year, duration, imdb_rating) VALUES('Serenity', 2019, 106, 5.3);
INSERT INTO public.movies(title, release_year, duration, imdb_rating) VALUES('Birds of Prey', 2020, 109, 6.2);


INSERT INTO public.actor_in_movie VALUES(1, 1);
INSERT INTO public.actor_in_movie VALUES(2, 1);
INSERT INTO public.actor_in_movie VALUES(3, 2);
INSERT INTO public.actor_in_movie VALUES(4, 2);


-- Completed on 2020-05-24 02:24:00

--
-- PostgreSQL database dump complete
--

